//
//  Cocoa::Object
//
//  See Copyright Notice in cocoa.h
//

#include "cocoa.h"
#include "cocoa_object.h"
#include "cocoa_type.h"
#include "cocoa_obj_hook.h"
#include "cfunc_pointer.h"
#include "cfunc_type.h"
#include "cfunc_closure.h"
#include "cfunc_utils.h"

#include "mruby/variable.h"
#include "mruby/string.h"
#include "mruby/class.h"
#include "mruby/data.h"

#include "ffi.h"

#include <stdbool.h>
#include <stdio.h>
#include <dlfcn.h>

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <objc/runtime.h>


static struct mrb_data_type cocoa_object_data_type;

/*
 * internal method
 */
static mrb_value
cocoa_object_new_with_id(mrb_state *mrb, id pointer)
{
    MrbObjectMap *assoc = objc_getAssociatedObject(pointer, cocoa_state(mrb)->object_association_key);
    if(assoc) {
        return assoc.mrb_obj;
    }

    struct cocoa_object_data *data;
    data = malloc(sizeof(struct cocoa_object_data));
    data->mrb = mrb;
    data->refer = false;
    data->autofree = false;
    data->autorelease = true;
    set_cfunc_pointer_data((struct cfunc_type_data *)data, (void*)pointer);
    [pointer retain];

    const char *class_name = object_getClassName(pointer);
    struct RClass *klass;

    mrb_sym class_name_sym = mrb_intern(mrb, class_name);
    if (mrb_const_defined_at(mrb, cocoa_state(mrb)->namespace, class_name_sym)) {
        klass = (struct RClass *)mrb_object(mrb_const_get(mrb, mrb_obj_value(cocoa_state(mrb)->namespace), class_name_sym));
    }
    else {
        klass = cocoa_state(mrb)->object_class;
    }

    mrb_value self = mrb_obj_value(Data_Wrap_Struct(mrb, klass, &cocoa_object_data_type, data));

    if(assoc == NULL) {
        assoc = [[MrbObjectMap alloc] init];
        objc_setAssociatedObject(pointer, cocoa_state(mrb)->object_association_key, assoc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [assoc release];
    }
    assoc.mrb_obj = self;
        
    mrb_value keeper = mrb_gv_get(mrb, cocoa_state(mrb)->sym_obj_holder);
    mrb_funcall_argv(mrb, keeper, mrb_intern(mrb, "push"), 1, &self);

    return self;
}


/*
 * call-seq:
 *  refer(pointer_of_pointer)
 *
 * Create a new object with pointer of pointer
 */
static mrb_value
cocoa_object_class_new(mrb_state *mrb, mrb_value klass)
{
    mrb_value pointer_mrb;
    mrb_get_args(mrb, "o", &pointer_mrb);
    id pointer = cfunc_pointer_ptr(pointer_mrb);

    MrbObjectMap *assoc = objc_getAssociatedObject(pointer, cocoa_state(mrb)->object_association_key);
    if(assoc) {
        return assoc.mrb_obj;
    }
    
    struct cocoa_object_data *data;
    data = malloc(sizeof(struct cocoa_object_data));
    data->mrb = mrb;
    data->refer = false;
    data->autofree = false;
    data->autorelease = true;
    set_cfunc_pointer_data((struct cfunc_type_data *)data, (void*)pointer);
    [pointer retain];
        
    //todo: should verify class
    const char *class_name = object_getClassName(pointer);
    struct RClass *klass2;
    if (mrb_const_defined(mrb, mrb_obj_value(mrb->object_class), mrb_intern(mrb, class_name))) {
        klass2 = mrb_class_get(mrb, class_name);
    }
    else {
        klass2 = cocoa_state(mrb)->object_class;
    }

    mrb_value self = mrb_obj_value(Data_Wrap_Struct(mrb, mrb_class_ptr(klass), &cocoa_object_data_type, data));
    
    if(assoc == NULL) {
        assoc = [[MrbObjectMap alloc] init];
        objc_setAssociatedObject(pointer, cocoa_state(mrb)->object_association_key, assoc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [assoc release];
    }
    assoc.mrb_obj = self;
    
    mrb_value keeper = mrb_gv_get(mrb, cocoa_state(data->mrb)->sym_obj_holder);
    mrb_funcall_argv(mrb, keeper, mrb_intern(mrb, "push"), 1, &self);

    return self;

}

/*
 * call-seq:
 *  refer(pointer_of_pointer)
 *
 * Create a new object with pointer of pointer
 */
static mrb_value
cocoa_object_class_refer(mrb_state *mrb, mrb_value klass)
{
    struct cocoa_object_data *data = malloc(sizeof(struct cocoa_object_data));
    data->mrb = mrb;
    data->autofree = false;
    data->refer = true;

    mrb_value pointer, noretain;
    if(mrb_get_args(mrb, "o|o", &pointer, &noretain) == 1) {
        noretain = mrb_nil_value();
    }

    id *obj = cfunc_pointer_ptr(pointer);
    if(*obj == nil) {
        return mrb_nil_value();
    }

    data->value._pointer = obj;

    MrbObjectMap *assoc = objc_getAssociatedObject(*obj, cocoa_state(mrb)->object_association_key);
    if(assoc) {
        return assoc.mrb_obj;
    }

    if(!mrb_test(noretain)) {
        [*obj retain];
    }
    data->autorelease = true;

    const char *class_name = object_getClassName(*obj);
    struct RClass *klass2;
    mrb_sym class_name_sym = mrb_intern(mrb, class_name);
    if (mrb_const_defined_at(mrb, cocoa_state(mrb)->namespace, class_name_sym)) {
        klass2 = (struct RClass *)mrb_object(mrb_const_get(mrb, mrb_obj_value(cocoa_state(mrb)->namespace), class_name_sym));
    }
    else {
        klass2 = cocoa_state(mrb)->object_class;
    }
    mrb_value self = mrb_obj_value(Data_Wrap_Struct(mrb, klass2, &cocoa_object_data_type, data));
    mrb_obj_iv_set(mrb, (struct RObject*)mrb_object(self), mrb_intern(mrb, "parent_pointer"), pointer); // keep for GC

    if(assoc == NULL && *obj) {
        assoc = [[MrbObjectMap alloc] init];
        objc_setAssociatedObject(*obj, cocoa_state(mrb)->object_association_key, assoc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [assoc release];
    }
    assoc.mrb_obj = self;

    mrb_value keeper = mrb_gv_get(mrb, cocoa_state(data->mrb)->sym_obj_holder);
    mrb_funcall_argv(mrb, keeper, mrb_intern(mrb, "push"), 1, &self);

    return self;
}


/*
 * internal method
 */
static Class
mruby_class_to_objc_class(mrb_state *mrb, struct RClass *klass)
{
    const char *class_name = mrb_class_name(mrb, klass);
    if(strncmp(class_name, "Cocoa::", 7)==0) {
        //mrb_raise(mrb, E_NAME_ERROR, "%s is not cocoa class", class_name);
        class_name += 7;
    }
    return NSClassFromString([NSString stringWithCString: class_name encoding:NSUTF8StringEncoding]);
}


/*
 * call-seq:
 *
 * Inspect this object
 */
static mrb_value
cocoa_object_inspect(mrb_state *mrb, mrb_value self)
{
    struct cocoa_object_data *data = DATA_PTR(self);
    
    NSMutableString *result = [NSMutableString stringWithFormat: @"<%@:%p", NSStringFromClass( [(id)(get_cfunc_pointer_data((struct cfunc_type_data *)data)) class] ), get_cfunc_pointer_data((struct cfunc_type_data *)data)];
    /*
    unsigned ivarCount = 0;
    Ivar *ivarList = class_copyIvarList( [data->pointer class], &ivarCount );
    
    for (unsigned i = 0; i < ivarCount; i++) {
        NSString *varName = [NSString stringWithUTF8String: ivar_getName( ivarList[i] )];
        [result appendFormat: @" %@=%@", varName, [data->pointer valueForKey: varName]];
    }
    free( ivarList );
    */
    [result appendString: @">"];
        
    return mrb_str_new(mrb, [result UTF8String], [result length]);
}


/*
 * call-seq:
 *  addClassMethod(selector, proc, encoded_args)
 *
 * Define a method to ObjC class with Ruby's proc
 */
static mrb_value
cocoa_object_class_objc_addMethod(mrb_state *mrb, mrb_value klass)
{
    mrb_value rb_method_name, rb_proc, rb_params;

    mrb_get_args(mrb, "ooo", &rb_method_name, &rb_proc, &rb_params);
    
    char *params = mrb_string_value_ptr(mrb, rb_params);
    char *method_name = mrb_string_value_ptr(mrb, rb_method_name);
    SEL sel = sel_registerName(method_name);
    
    Class objc_klass = mruby_class_to_objc_class(mrb, (struct RClass *)mrb_object(klass));

    void *closure = cfunc_closure_data_pointer(mrb, rb_proc);
    class_addMethod(objc_klass, sel, closure, params);
    
    return mrb_nil_value();
}


#define SELF_AND_SEL (2)
/*
 * call-seq:
 *  msgSend(selector, args...)
 *
 * Send a message to a object
 */
static mrb_value
cocoa_object_objc_msgSend(mrb_state *mrb, mrb_value self)
{
    struct cocoa_object_data *data = DATA_PTR(self);

    mrb_value mresult = mrb_nil_value();
    void **values = NULL;
    mrb_value *arg_type_class = NULL;
    ffi_type **arg_types = NULL;

    int margc, i;
    mrb_value method_name_mrb, *margs;
    mrb_get_args(mrb, "o*", &method_name_mrb, &margs, &margc);

    char *method_name = mrb_string_value_ptr(mrb, method_name_mrb);
    SEL sel = NSSelectorFromString([NSString stringWithCString: method_name encoding:NSUTF8StringEncoding]);

    int cocoa_argc = margc + SELF_AND_SEL;

    id obj = get_cfunc_pointer_data((struct cfunc_type_data *)data);
    Method method;
    if(obj == [obj class]) { // if(self is class) 
        method = class_getClassMethod(obj, sel);
    }
    else {
        method = class_getInstanceMethod([(id)(get_cfunc_pointer_data((struct cfunc_type_data *)data)) class], sel);
    }
    if(method == NULL) {
        mrb_raise(mrb, E_NOMETHOD_ERROR, "no method name: %s", method_name);
    }
    
    unsigned cocoa_method_argc = method_getNumberOfArguments(method);
    void *fp = method_getImplementation(method);
    
    if(cocoa_method_argc > cocoa_argc) {
        mrb_raise(mrb, E_ARGUMENT_ERROR, "ignore arguments number");
    }
    
    arg_type_class = malloc(sizeof(mrb_value) * cocoa_argc);
    arg_types = malloc(sizeof(ffi_type*) * cocoa_argc);
    for(i = 0; i < cocoa_method_argc; i++) {
        char *argtype = method_copyArgumentType(method, i);
        arg_type_class[i] = objc_type_to_cfunc_type(mrb, argtype);
        free(argtype);
        arg_types[i] = rclass_to_mrb_ffi_type(mrb, mrb_class_ptr(arg_type_class[i]))->ffi_type_value;
    }

    for(;i < cocoa_argc; i++) {
        arg_types[i] = mrb_value_to_mrb_ffi_type(mrb, margs[i - 2])->ffi_type_value;
    }
    
    values = malloc(sizeof(void*) * cocoa_argc);
    
    values[0] = malloc(sizeof(void*));
    *((void***)values)[0] = get_cfunc_pointer_data((struct cfunc_type_data *)data);
    
    values[1] = malloc(sizeof(void*));
    *((void***)values)[1] = sel;
    
    mrb_sym sym_to_pointer = mrb_intern(mrb, "to_pointer");
    for(i = SELF_AND_SEL; i < cocoa_argc; ++i) {
        if(mrb_respond_to(mrb, margs[i - SELF_AND_SEL], sym_to_pointer)) {
            values[i] = cfunc_pointer_ptr(mrb_funcall(mrb, margs[i - SELF_AND_SEL], "to_pointer", 0));
        }
        else {
            mrb_value mval = mrb_funcall(mrb, arg_type_class[i], "new", 1, margs[i - SELF_AND_SEL]);
            values[i] = cfunc_pointer_ptr(mrb_funcall(mrb, mval, "to_pointer", 0));
        }
    }
    
    char *result_cocoa_type = method_copyReturnType(method);
    mrb_value result_type_class = objc_type_to_cfunc_type(mrb, result_cocoa_type);
    free(result_cocoa_type);

    ffi_type *result_ffi_type = rclass_to_mrb_ffi_type(mrb, mrb_class_ptr(result_type_class))->ffi_type_value;
    void *result_ptr = malloc(result_ffi_type->size);
    if(result_ffi_type->type == FFI_TYPE_STRUCT) {
        int size = mrb_fixnum(mrb_funcall(mrb, result_type_class, "size", 0));
        result_ptr = malloc(size);
    }

    ffi_cif cif;
    if (ffi_prep_cif(&cif, FFI_DEFAULT_ABI, cocoa_argc, result_ffi_type, arg_types) == FFI_OK) {
        // todo: should handling objective-c exception
        ffi_call(&cif, fp, result_ptr, values);
        mrb_value mresult_p = cfunc_pointer_new_with_pointer(mrb, result_ptr, 1);
        if(strcmp("alloc", method_name) == 0) {
            mresult = mrb_funcall(mrb, result_type_class, "refer", 2, mresult_p, mrb_true_value());
        }
        else {
            mresult = mrb_funcall(mrb, result_type_class, "refer", 1, mresult_p);
        }
    }
    else {
        free(result_ptr);
        cfunc_mrb_raise_without_jump(mrb, E_NAME_ERROR, "can't find method %s", method_name);
        goto error_exit;
    }
    
error_exit:
    if(values) {
        for(i = 0; i < SELF_AND_SEL; ++i) {
            free(values[i]);
        }
        free(values);
    }
    free(arg_types);
    free(arg_type_class);

    return mresult;
}


/*
 * call-seq:
 *  msgSend(selector, args...)
 *
 * Send a message to a class
 */
static mrb_value
cocoa_object_class_objc_msgSend(mrb_state *mrb, mrb_value klass)
{
    Class objc_klass = mruby_class_to_objc_class(mrb, (struct RClass *)mrb_object(klass));
    mrb_value obj = cocoa_object_new_with_id(mrb, objc_klass);
    
    return cocoa_object_objc_msgSend(mrb, obj);
}


/*
 * internal method
 *
 * create new ObjC class when created Ruby class
 */
static mrb_value
cocoa_object_class_inherited(mrb_state *mrb, mrb_value klass)
{
    mrb_value subclass;
    mrb_get_args(mrb, "o", &subclass);

    Class objc_klass = mruby_class_to_objc_class(mrb, (struct RClass *)mrb_object(subclass));

    if(!objc_klass) {
        const char *class_name = mrb_class_name(mrb, (struct RClass *)mrb_object(subclass));
        if(strncmp(class_name, "Cocoa::", 7)!=0) { // todo
            mrb_raise(mrb, E_NAME_ERROR, "%s should define under Cocoa module", class_name);
        }
        class_name += 7; // todo
        Class super_class = mruby_class_to_objc_class(mrb, (struct RClass *)mrb_object(klass));
        Class new_class = objc_allocateClassPair(super_class, class_name, 0);
        objc_registerClassPair(new_class);
    }

    return mrb_nil_value();
}


/*
 * call-seq:
 *  [prop]
 *
 * Get propety value
 */
static mrb_value
cocoa_object_class_objc_property_getAttributes(mrb_state *mrb, mrb_value self)
{
    struct cocoa_object_data *data = DATA_PTR(self);

    mrb_value prop_name;
    mrb_get_args(mrb, "o", &prop_name);
    
    id obj = get_cfunc_pointer_data((struct cfunc_type_data *)data);
    Class objc_klass = [obj class];
    
    objc_property_t prop = class_getProperty(objc_klass, mrb_string_value_ptr(mrb, prop_name));
    if(!prop) {
        return mrb_nil_value();
    }
    const char *attrs = property_getAttributes(prop);
    
    // T{YorkshireTeaStruct="pot"i"lady"c},VtypedefDefault
    // Ti,GintGetFoo,SintSetFoo:,VintSetterGetter
    return mrb_str_new(mrb, attrs, strlen(attrs));
}


/*
 * internal function
 */
static void
cocoa_object_destructor(mrb_state *mrb, void *p)
{
    struct cocoa_object_data *data = p;

    id obj = get_cfunc_pointer_data((struct cfunc_type_data *)data);
    MrbObjectMap *assoc = objc_getAssociatedObject(obj, cocoa_state(data->mrb)->object_association_key);

    if(data->autorelease) {
        [obj release];
    }
    free(p);
}

mrb_value
cocoa_class_exists_cocoa_class(mrb_state *mrb, mrb_value klass)
{
    mrb_value class_name_mrb;
    mrb_get_args(mrb, "o", &class_name_mrb);
    const char *class_name = mrb_sym2name(mrb, mrb_symbol(class_name_mrb));

    if(NSClassFromString([NSString stringWithCString:class_name encoding:NSUTF8StringEncoding])) {
        return mrb_true_value();
    }
    else {
        return mrb_false_value();
    }
}


mrb_value
cocoa_class_load_cocoa_class(mrb_state *mrb, mrb_value klass)
{
    mrb_value class_name_mrb;
    mrb_get_args(mrb, "o", &class_name_mrb);
    const char *class_name = mrb_sym2name(mrb, mrb_symbol(class_name_mrb));
    
    if(!NSClassFromString([NSString stringWithCString:class_name encoding:NSUTF8StringEncoding])) {
       mrb_raise(mrb, E_NAME_ERROR, "can't load %s class from Cocoa", class_name);
    }
    
    struct RClass *object_class = cocoa_state(mrb)->object_class;
    return mrb_obj_value(mrb_define_class_under(mrb, cocoa_state(mrb)->namespace, class_name, object_class));
}


/*
 * internal data
 */
static struct mrb_data_type cocoa_object_data_type = {
    "cocoa_object", cocoa_object_destructor,
};


/*
 * initialize function
 */
void
init_cocoa_object(mrb_state *mrb, struct RClass* module)
{
    struct RClass *object_class = mrb_define_class_under(mrb, module, "Object", cfunc_state(mrb)->pointer_class);
    cocoa_state(mrb)->object_class = object_class;
    cocoa_state(mrb)->sym_obj_holder = mrb_intern(mrb, "$mobiruby_obj_holder");
    cocoa_state(mrb)->sym_delete = mrb_intern(mrb, "delete");

    mrb_define_class_method(mrb, object_class, "refer", cocoa_object_class_refer, ARGS_REQ(2));
    mrb_define_class_method(mrb, object_class, "objc_addMethod", cocoa_object_class_objc_addMethod, ARGS_ANY());
    mrb_define_class_method(mrb, object_class, "objc_msgSend", cocoa_object_class_objc_msgSend, ARGS_ANY());
    mrb_define_class_method(mrb, object_class, "new", cocoa_object_class_new, ARGS_REQ(1));

    mrb_define_class_method(mrb, object_class, "load_cocoa_class", cocoa_class_load_cocoa_class, ARGS_REQ(1));
    mrb_define_class_method(mrb, object_class, "exists_cocoa_class?", cocoa_class_exists_cocoa_class, ARGS_REQ(1));

    mrb_define_class_method(mrb, object_class, "inherited", cocoa_object_class_inherited, ARGS_REQ(1));
    mrb_define_method(mrb, object_class, "objc_property_getAttributes", cocoa_object_class_objc_property_getAttributes, ARGS_ANY());
    mrb_define_method(mrb, object_class, "objc_msgSend", cocoa_object_objc_msgSend, ARGS_ANY());
    mrb_define_method(mrb, object_class, "inspect", cocoa_object_inspect, ARGS_NONE());
}
