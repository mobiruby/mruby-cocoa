//
//  BridgeSupport loader
//
//  See Copyright Notice in cocoa.h
//

#include "cocoa_bridgesupport.h"
#include "cocoa_type.h"
#include "cocoa.h"
#include "cfunc.h"
#include "cfunc_struct.h"

#include "mruby.h"
#include "mruby/string.h"
#include "mruby/variable.h"

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <objc/runtime.h>

struct StructTable
{
    const char *name;
    const char *definition;
}
struct_table[] = {
    {.name = "CGPoint", .definition = "x:f:y:f"},
    {.name = "CGSize", .definition = "width:f:height:f"},
    {.name = "CGRect", .definition = "origin:{CGPoint}:size:{CGSize}"},
    {.name = "MobiCocoaStruct1", .definition = "i:i:d:d:str:*:obj:@:iptr:^i"},
    {.name = "MobiCocoaStruct2", .definition = "i1:i:i2:i"},
    {.name = NULL, .definition = NULL}
};


const char* cocoa_bridgesupport_struct_lookup(mrb_state *mrb, const char *name)
{
    struct StructTable *cur = struct_table;
    while(cur->name) {
        if(strcmp(name, cur->name)==0) {
            return cur->definition;
        }
        ++cur;
    }
    return NULL;
}


mrb_value
cocoa_struct_const_missing(mrb_state *mrb, mrb_value klass)
{
    mrb_value name;
    mrb_get_args(mrb, "o", &name);
    char *namestr = mrb_string_value_ptr(mrb, name);

    const char *definition = cocoa_bridgesupport_struct_lookup(mrb, namestr);
    if(definition) {
        char *type = malloc(strlen(namestr) + 4);
        strcpy(type, "{");
        strcat(type, namestr);
        strcat(type, "=}");
        mrb_value strct = objc_type_to_cfunc_type(mrb, type);
        return strct;
    }
    else {
        // todo: raise unknow struct exception
        return mrb_nil_value();
    }
}


/*
 * initialize function
 */
void
init_cocoa_bridge_support(mrb_state *mrb)
{
    struct RClass *struct_class = mrb_define_module_under(mrb, cocoa_state(mrb)->namespace, "Struct");
    cocoa_state(mrb)->struct_class = struct_class;
    mrb_define_class_method(mrb, struct_class, "const_missing", cocoa_struct_const_missing, ARGS_REQ(1));

    
}
