//
//  Cocoa::Object
//
//  See Copyright Notice in cocoa.h
//

#include "cocoa.h"
#include "cocoa_object.h"
#include "cocoa_type.h"
#include "cocoa_st.h"
#include "cocoa_obj_hook.h"
#include "cfunc_pointer.h"
#include "cfunc_type.h"
#include "cfunc_closure.h"
#include "cfunc_utils.h"

#include "mruby/variable.h"
#include "mruby/string.h"
#include "mruby/class.h"
#include "mruby/data.h"
#include "mruby/array.h"

#include "ffi.h"

#include <stdbool.h>
#include <stdio.h>
#include <dlfcn.h>

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define DONE mrb_gc_arena_restore(mrb, 0);

static struct mrb_data_type cocoa_object_data_type;


/*
 * internal method
 */
mrb_value
cocoa_object_new_with_id(mrb_state *mrb, id pointer)
{
    //printf("new_with_id=%p\n", pointer);
    struct cocoa_state *cs = cocoa_state(mrb);
    MrbObjectMap *assoc = objc_getAssociatedObject(pointer, cs->object_association_key);
    if(assoc) {
        return assoc.mrb_obj;
    }

    struct cocoa_object_data *data;
    data = mrb_malloc(mrb, sizeof(struct cocoa_object_data));
    data->mrb = mrb;
    data->refer = false;
    data->autofree = false;
    data->autorelease = true;
    set_cfunc_pointer_data((struct cfunc_type_data *)data, (void*)pointer);
    if(cocoa_swizzle_release(pointer)) {
        [pointer retain];
    }

    const char *class_name = object_getClassName(pointer);
    struct RClass *klass;

    mrb_sym class_name_sym = mrb_intern(mrb, class_name);
    if (mrb_const_defined_at(mrb, cs->namespace, class_name_sym)) {
        klass = (struct RClass *)mrb_object(mrb_const_get(mrb, mrb_obj_value(cs->namespace), class_name_sym));
    }
    else {
        klass = cs->object_class;
    }

    mrb_value self = mrb_obj_value(Data_Wrap_Struct(mrb, klass, &cocoa_object_data_type, data));

    if(assoc == NULL) {
        assoc = [[MrbObjectMap alloc] init];
        objc_setAssociatedObject(pointer, cs->object_association_key, assoc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [assoc release];
    }
    assoc.mrb_obj = self;
        
    mrb_value keeper = mrb_gv_get(mrb, cs->sym_obj_holder);
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
    struct cocoa_state *cs = cocoa_state(mrb);

    mrb_value pointer_mrb;
    mrb_get_args(mrb, "o", &pointer_mrb);
    id pointer = cfunc_pointer_ptr(pointer_mrb);
    //printf("new=%p\n", pointer);

    MrbObjectMap *assoc = objc_getAssociatedObject(pointer, cs->object_association_key);
    if(assoc) {
        //puts(">>>");
        //mrb_p(mrb, assoc.mrb_obj);
        return assoc.mrb_obj;
    }
    
    struct cocoa_object_data *data;
    data = mrb_malloc(mrb, sizeof(struct cocoa_object_data));
    data->mrb = mrb;
    data->refer = false;
    data->autofree = false;
    data->autorelease = true;
    set_cfunc_pointer_data((struct cfunc_type_data *)data, (void*)pointer);
    if(cocoa_swizzle_release(pointer)) {
        [pointer retain];
    }
        
    //todo: should verify class
    const char *class_name = object_getClassName(pointer);
    struct RClass *klass2;
    if (mrb_const_defined(mrb, mrb_obj_value(mrb->object_class), mrb_intern(mrb, class_name))) {
        klass2 = mrb_class_get(mrb, class_name);
    }
    else {
        klass2 = cs->object_class;
    }

    mrb_value self = mrb_obj_value(Data_Wrap_Struct(mrb, mrb_class_ptr(klass), &cocoa_object_data_type, data));
    
    if(assoc == NULL) {
        assoc = [[MrbObjectMap alloc] init];
        objc_setAssociatedObject(pointer, cs->object_association_key, assoc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [assoc release];
    }
    assoc.mrb_obj = self;
    
    mrb_value keeper = mrb_gv_get(mrb, cs->sym_obj_holder);
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
    struct cocoa_state *cs = cocoa_state(mrb);

    mrb_value pointer;
    mrb_get_args(mrb, "o", &pointer);

    id obj = *(id*)cfunc_pointer_ptr(pointer);
    if(obj == nil) {
        return mrb_nil_value();
    }

    MrbObjectMap *assoc = objc_getAssociatedObject(obj, cs->object_association_key);
    if(assoc) {
    //printf("refer assoc=%p\n",obj);
        return assoc.mrb_obj;
    }
    //printf("refer=%p\n", obj);

    struct cocoa_object_data *data = mrb_malloc(mrb, sizeof(struct cocoa_object_data));
    data->mrb = mrb;
    data->refer = true;
    data->autofree = true;
    data->autorelease = true;

    data->value._pointer = mrb_malloc(mrb, sizeof(id));
    *((id*)data->value._pointer) = obj;

    if(cocoa_swizzle_release(obj)) {
        [obj retain];
    }

    const char *class_name = object_getClassName(obj);
    struct RClass *klass2;
    mrb_sym class_name_sym = mrb_intern(mrb, class_name);
    if (mrb_const_defined_at(mrb, cs->namespace, class_name_sym)) {
        klass2 = (struct RClass *)mrb_object(mrb_const_get(mrb, mrb_obj_value(cs->namespace), class_name_sym));
    }
    else {
        klass2 = cs->object_class;
    }
    mrb_value self = mrb_obj_value(Data_Wrap_Struct(mrb, klass2, &cocoa_object_data_type, data));
    mrb_obj_iv_set(mrb, (struct RObject*)mrb_object(self), mrb_intern(mrb, "parent_pointer"), pointer); // keep for GC

    if(assoc == NULL && obj) {
        assoc = [[[MrbObjectMap alloc] init] autorelease];
        objc_setAssociatedObject(obj, cs->object_association_key, assoc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    assoc.mrb_obj = self;

    mrb_value keeper = mrb_gv_get(mrb, cs->sym_obj_holder);
    mrb_funcall_argv(mrb, keeper, mrb_intern(mrb, "push"), 1, &self);
    //mrb_p(mrb, self);
    //mrb_p(mrb, keeper);
    //printf(">>refer=%p\n", obj);

    return self;
}


/*
 * internal method
 */
static Class
mruby_class_to_objc_class(mrb_state *mrb, struct RClass *klass)
{
    struct cocoa_state *cs = cocoa_state(mrb);

    Class objc_class;
    if(cocoa_st_lookup(cs->cocoa_classes, (cocoa_st_data_t)klass, (void*)&objc_class)) {
        return objc_class;
    }

    const char *class_name = mrb_class_name(mrb, klass);
    if(strncmp(class_name, "Cocoa::", 7)==0) {
        //mrb_raisef(mrb, E_NAME_ERROR, "%s is not cocoa class", class_name);
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
    mrb_free(mrb,  ivarList );
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


/*
 * call-seq:
 *  addClassMethod(selector, proc, encoded_args)
 *
 * Define a method to ObjC class with Ruby's proc
 */
static mrb_value
cocoa_object_class_objc_addClassMethod(mrb_state *mrb, mrb_value klass)
{
    mrb_value rb_method_name, rb_proc, rb_params;

    mrb_get_args(mrb, "ooo", &rb_method_name, &rb_proc, &rb_params);
    
    char *params = mrb_string_value_ptr(mrb, rb_params);
    char *method_name = mrb_string_value_ptr(mrb, rb_method_name);
    SEL sel = sel_registerName(method_name);
    
    Class objc_klass = mruby_class_to_objc_class(mrb, (struct RClass *)mrb_object(klass));

    void *closure = cfunc_closure_data_pointer(mrb, rb_proc);
    class_addMethod(object_getClass(objc_klass), sel, closure, params);
    
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
    ffi_type **arg_types = NULL;

    int margc, i;
    mrb_value method_name_mrb, *margs;
    mrb_sym target;
    mrb_get_args(mrb, "no*", &target, &method_name_mrb, &margs, &margc);

    char *method_name = mrb_string_value_ptr(mrb, method_name_mrb);
    SEL sel = NSSelectorFromString([NSString stringWithCString: method_name encoding:NSUTF8StringEncoding]);

    int cocoa_argc = margc + SELF_AND_SEL;

    id obj = get_cfunc_pointer_data((struct cfunc_type_data *)data);
    NSMethodSignature *signature = nil;
    void *method = nil;
    Class klass;
    if(obj == [obj class]) { // if(self is class)
        if(target == mrb_intern(mrb, "super")) {
        klass = [obj superclass];
            signature = [klass methodSignatureForSelector: sel];
            method = [klass methodForSelector: sel];
        }
        else {
            signature = [obj methodSignatureForSelector: sel];
            method = [obj methodForSelector: sel];
        }
    }
    else {
        klass = [obj class];
        if(target == mrb_intern(mrb, "super")) {
        klass = [obj superclass];
            signature = [klass instanceMethodSignatureForSelector: sel];
            method = [klass instanceMethodForSelector: sel];
        }
        else {
            signature = [obj methodSignatureForSelector: sel];
            method = [obj methodForSelector: sel];
        }
    }
    if(method == NULL) {
        mrb_raisef(mrb, E_NOMETHOD_ERROR, "no method name: %s", method_name);
    }

    mrb_sym sym_to_ffi_value = mrb_intern(mrb, "to_ffi_value");
 
    //printf("m3 %s\n",method_name);
    arg_types = mrb_malloc(mrb, sizeof(ffi_type*) * (margc + SELF_AND_SEL));
    arg_types[0] = &ffi_type_pointer;
    arg_types[1] = &ffi_type_pointer;
    values = mrb_malloc(mrb, sizeof(void*) * cocoa_argc);
    for(i = 0; i < margc; i++) {
        mrb_value marg = margs[i];
        if(i >= [signature numberOfArguments] - SELF_AND_SEL) {
            arg_types[i + SELF_AND_SEL] = mrb_value_to_mrb_ffi_type(mrb, marg)->ffi_type_value;
            mrb_value args[1];
            args[0] = mrb_nil_value();
            marg = mrb_funcall_argv(mrb, marg, sym_to_ffi_value, 1, args);
        }
        else {
            const char *argtype = [signature getArgumentTypeAtIndex:i + SELF_AND_SEL];
            mrb_value arg_type_class = objc_type_to_cfunc_type(mrb, argtype);
            arg_types[i + SELF_AND_SEL] = rclass_to_mrb_ffi_type(mrb, mrb_class_ptr(arg_type_class))->ffi_type_value;
            if(!mrb_respond_to(mrb, marg, sym_to_ffi_value)) {
                marg = mrb_funcall(mrb, arg_type_class, "new", 1, marg);
            }
            mrb_value args[1];
            args[0] = arg_type_class;
            marg = mrb_funcall_argv(mrb, marg, sym_to_ffi_value, 1, args);
        }
        values[i + SELF_AND_SEL] = cfunc_pointer_ptr(marg);
    }
    
    values[0] = mrb_malloc(mrb, sizeof(void*));
    *((void***)values)[0] = obj;
    
    values[1] = mrb_malloc(mrb, sizeof(void*));
    *((void***)values)[1] = sel;
    
    void *result_ptr = NULL;
    ffi_type *result_ffi_type = &ffi_type_void;
    mrb_value result_type_class;
    const char *ret_type = [signature methodReturnType];
    if(ret_type) {
        result_type_class = objc_type_to_cfunc_type(mrb, ret_type);
        result_ffi_type = rclass_to_mrb_ffi_type(mrb, mrb_class_ptr(result_type_class))->ffi_type_value;
        result_ptr = mrb_malloc(mrb, [signature methodReturnLength]);
    }
    ffi_cif cif;
    if (ffi_prep_cif(&cif, FFI_DEFAULT_ABI, cocoa_argc, result_ffi_type, arg_types) == FFI_OK) {
        @try {
            ffi_call(&cif, method, result_ptr, values);
        }
        @catch (NSException *exception) {
            cfunc_mrb_raise_without_jump(mrb, mrb_class_get(mrb, "ObjCException"), "%s:%s", [[exception name] UTF8String], [[exception reason] UTF8String]);
            goto error_exit;
        }
        if(result_ptr) {
            mrb_value mresult_p = cfunc_pointer_new_with_pointer(mrb, result_ptr, 1);
            if(strcmp("alloc", method_name) == 0) {
                mresult = mrb_funcall(mrb, result_type_class, "refer", 1, mresult_p);
                [(*(id*)result_ptr) autorelease];
            }
            else {
                mresult = mrb_funcall(mrb, result_type_class, "refer", 1, mresult_p);
            }
        }
    }
    else {
        mrb_free(mrb, result_ptr);
        cfunc_mrb_raise_without_jump(mrb, E_NAME_ERROR, "can't find method %s", method_name);
        goto error_exit;
    }
    //printf("m8 %s\n",method_name);
    
error_exit:
    if(values) {
        for(i = 0; i < SELF_AND_SEL; ++i) {
            mrb_free(mrb, values[i]);
        }
        mrb_free(mrb, values);
    }
    mrb_free(mrb, arg_types);
//    [pool release];

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
    struct cocoa_state *cs = cocoa_state(mrb);

    mrb_value subclass;
    mrb_get_args(mrb, "o", &subclass);

    Class objc_klass = mruby_class_to_objc_class(mrb, (struct RClass *)mrb_object(subclass));

    if(!objc_klass) {
        const char *class_name = mrb_class_name(mrb, (struct RClass *)mrb_object(subclass));
        if(strncmp(class_name, "Cocoa::", 7)!=0) { // todo
            mrb_raisef(mrb, E_NAME_ERROR, "%s should define under Cocoa module", class_name);
        }
        class_name += 7; // todo
        Class super_class = mruby_class_to_objc_class(mrb, (struct RClass *)mrb_object(klass));
        objc_klass = objc_allocateClassPair(super_class, class_name, 0);

        cocoa_st_insert(cs->cocoa_classes, (cocoa_st_data_t)mrb_object(subclass), (cocoa_st_data_t)objc_klass);
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
    
    if(data->autorelease) {
        [obj release];
    }
    mrb_free(mrb, p);
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
cocoa_object_class_set(mrb_state *mrb, mrb_value klass)
{
    struct cocoa_state *cs = cocoa_state(mrb);

    mrb_value pointer, val;
    mrb_get_args(mrb, "oo", &pointer, &val);

    id *valp = cfunc_pointer_ptr(mrb_funcall(mrb, val, "to_ffi_value", 1, mrb_obj_value(cs->object_class)));
    *((id*)cfunc_pointer_ptr(pointer)) = *valp;

    return val;
}


mrb_value
cocoa_class_load_cocoa_class(mrb_state *mrb, mrb_value klass)
{
    struct cocoa_state *cs = cocoa_state(mrb);

    mrb_value class_name_mrb;
    mrb_get_args(mrb, "o", &class_name_mrb);
    const char *class_name = mrb_sym2name(mrb, mrb_symbol(class_name_mrb));
    
    if(!NSClassFromString([NSString stringWithCString:class_name encoding:NSUTF8StringEncoding])) {
       mrb_raisef(mrb, E_NAME_ERROR, "Can't load %s class in Cocoa", class_name);
    }
    
    struct RClass *object_class = cs->object_class;
    return mrb_obj_value(mrb_define_class_under(mrb, cs->namespace, class_name, object_class));
}


mrb_value
cocoa_object_class_protocol(mrb_state *mrb, mrb_value klass)
{
    Class objc_class = mruby_class_to_objc_class(mrb, (struct RClass *)mrb_object(klass));
        
    mrb_value *params;
    int params_count;
    mrb_get_args(mrb, "*", &params, &params_count);

    for(int i = 0; i < params_count; ++i) {
        mrb_value name = mrb_funcall(mrb, params[i], "to_s", 0);
        struct RString *str = mrb_str_ptr(name);
        Protocol *protocol = objc_getProtocol(str->ptr);
        if(!protocol) {
            mrb_raisef(mrb, E_NAME_ERROR, "Can't find %s protocol in Cocoa", str->ptr);
        }
        class_addProtocol(objc_class, protocol);
    }

    return klass;
}


mrb_value
cocoa_class_register(mrb_state *mrb, mrb_value klass)
{
    struct cocoa_state *cs = cocoa_state(mrb);

    Class objc_class;
    if(cocoa_st_lookup(cs->cocoa_classes, (cocoa_st_data_t)mrb_object(klass), (void*)&objc_class)) {
        objc_registerClassPair(objc_class);
    }
    
    return klass;
}


mrb_value
cocoa_class_addr(mrb_state *mrb, mrb_value klass)
{
    struct cocoa_state *cs = cocoa_state(mrb);

    Class objc_class;
    if(cocoa_st_lookup(cs->cocoa_classes, (cocoa_st_data_t)mrb_object(klass), (void*)&objc_class)) {
        return cfunc_pointer_new_with_pointer(mrb, objc_class, 0);
    }
    
    return mrb_nil_value();
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
    struct cocoa_state *cs = cocoa_state(mrb);
    struct RClass *object_class = mrb_define_class_under(mrb, module, "Object", cfunc_state(mrb, NULL)->pointer_class);

    cs->object_class = object_class;
    cs->sym_obj_holder = mrb_intern(mrb, "$mobiruby_obj_holder");
    cs->sym_delete = mrb_intern(mrb, "delete");
    cs->cocoa_classes = cocoa_st_init_pointertable();

    mrb_define_class_method(mrb, object_class, "objc_addMethod", cocoa_object_class_objc_addMethod, ARGS_ANY());
    mrb_define_class_method(mrb, object_class, "objc_addClassMethod", cocoa_object_class_objc_addClassMethod, ARGS_ANY());
    mrb_define_class_method(mrb, object_class, "objc_msgSend", cocoa_object_class_objc_msgSend, ARGS_ANY());
    mrb_define_class_method(mrb, object_class, "protocol", cocoa_object_class_protocol, ARGS_ANY());
    DONE;

    mrb_define_class_method(mrb, object_class, "refer", cocoa_object_class_refer, ARGS_REQ(2));
    mrb_define_class_method(mrb, object_class, "new", cocoa_object_class_new, ARGS_REQ(1));
    mrb_define_class_method(mrb, object_class, "set", cocoa_object_class_set, ARGS_REQ(2));
    DONE;
    
    mrb_define_class_method(mrb, object_class, "load_cocoa_class", cocoa_class_load_cocoa_class, ARGS_REQ(1));
    mrb_define_class_method(mrb, object_class, "exists_cocoa_class?", cocoa_class_exists_cocoa_class, ARGS_REQ(1));
    DONE;

    mrb_define_class_method(mrb, object_class, "register", cocoa_class_register, ARGS_NONE());
    mrb_define_class_method(mrb, object_class, "addr", cocoa_class_addr, ARGS_NONE());
    DONE;

    mrb_define_class_method(mrb, object_class, "inherited", cocoa_object_class_inherited, ARGS_REQ(1));
    DONE;

    mrb_define_method(mrb, object_class, "objc_property_getAttributes", cocoa_object_class_objc_property_getAttributes, ARGS_ANY());
    mrb_define_method(mrb, object_class, "objc_msgSend", cocoa_object_objc_msgSend, ARGS_ANY());
    mrb_define_method(mrb, object_class, "inspect", cocoa_object_inspect, ARGS_NONE());
    DONE;
}
