//
//  BridgeSupport support
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
#import <objc/runtime.h>

void
load_cocoa_bridgesupport(mrb_state *mrb,
    struct BridgeSupportStructTable *struct_table,
    struct BridgeSupportConstTable *const_table,
    struct BridgeSupportEnumTable *enum_table)
{
    cocoa_state(mrb)->struct_table = struct_table;
    cocoa_state(mrb)->const_table = const_table;
    cocoa_state(mrb)->enum_table = enum_table;
}


// Need to re-write to hash table
const char*
cocoa_bridgesupport_struct_lookup(mrb_state *mrb, const char *name)
{
    if(cocoa_state(mrb)->struct_table == NULL) {
        return NULL;
    }

    struct BridgeSupportStructTable *cur = cocoa_state(mrb)->struct_table;
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
    if(cocoa_state(mrb)->const_table == NULL) {
        return mrb_nil_value();
    }

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
        mrb_define_const(mrb, (struct RClass*)mrb_object(klass), namestr, strct);
        return strct;
    }
    else {
        // todo: raise unknow struct exception
        printf("Unknown %s\n", namestr);
        return mrb_nil_value();
    }
}


mrb_value
cocoa_const_const_missing(mrb_state *mrb, mrb_value klass)
{
    if(cocoa_state(mrb)->const_table == NULL) {
        return mrb_nil_value();
    }

    mrb_value name;
    mrb_get_args(mrb, "o", &name);
    char *namestr = mrb_string_value_ptr(mrb, name);

    struct BridgeSupportConstTable *ccur = cocoa_state(mrb)->const_table;
    while(ccur->name) {
        if(strcmp(namestr, ccur->name)==0) {
            mrb_value type = objc_type_to_cfunc_type(mrb, ccur->type);

            mrb_value ptr = cfunc_pointer_new_with_pointer(mrb, ccur->value, false);
            return mrb_funcall(mrb, type, "refer", 1, ptr);
        }
        ++ccur;
    }

    struct BridgeSupportEnumTable *ecur = cocoa_state(mrb)->enum_table;
    while(ecur->name) {
        if(strcmp(namestr, ecur->name)==0) {
            return ecur->value;
        }
        ++ecur;
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

    cocoa_state(mrb)->const_table = NULL;
    cocoa_state(mrb)->struct_table = NULL;
}
