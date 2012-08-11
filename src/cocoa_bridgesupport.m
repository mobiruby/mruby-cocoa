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
#include "cfunc_pointer.h"

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


struct ConstTable
{
    const char *name;
    const char *type;
    void *value;
}
const_table[] = {
    {.name = "kCFAbsoluteTimeIntervalSince1904", .type = "d", .value = &kCFAbsoluteTimeIntervalSince1904},
    {.name = "kCFNumberFormatterCurrencyCode", .type = "^{__CFString=}", .value = &kCFNumberFormatterCurrencyCode},
    {.name = "kCFTypeArrayCallBacks", .type = "{_CFArrayCallBacks=i^?^?^?^?}", .value = &kCFTypeArrayCallBacks},
    {.name = NULL, .type = NULL, .value = NULL}
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


mrb_value
cocoa_const_const_missing(mrb_state *mrb, mrb_value klass)
{
    mrb_value name;
    mrb_get_args(mrb, "o", &name);
    char *namestr = mrb_string_value_ptr(mrb, name);

    struct ConstTable *cur = const_table;
    while(cur->name) {
        if(strcmp(namestr, cur->name)==0) {
            mrb_value type = objc_type_to_cfunc_type(mrb, cur->type);
            mrb_value ptr = cfunc_pointer_new_with_pointer(mrb, cur->value, false);
            return mrb_funcall(mrb, type, "refer", 1, ptr);
        }
        ++cur;
    }
    return mrb_nil_value();
}


/*
 * initialize function
 */
void
init_cocoa_bridge_support(mrb_state *mrb)
{
    struct RClass *struct_module = mrb_define_module_under(mrb, cocoa_state(mrb)->namespace, "Struct");
    cocoa_state(mrb)->struct_module = struct_module;
    mrb_define_class_method(mrb, struct_module, "const_missing", cocoa_struct_const_missing, ARGS_REQ(1));

    struct RClass *const_module = mrb_define_module_under(mrb, cocoa_state(mrb)->namespace, "Const");
    cocoa_state(mrb)->const_module = const_module;
    mrb_define_class_method(mrb, const_module, "const_missing", cocoa_const_const_missing, ARGS_REQ(1));
    mrb_define_class_method(mrb, const_module, "method_missing", cocoa_const_const_missing, ARGS_REQ(1));
}
