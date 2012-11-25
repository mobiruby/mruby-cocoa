//
//  hook objective-c object
//
//  See Copyright Notice in cocoa.h
//

#include "cocoa_obj_hook.h"
#include "cocoa_st.h"
#include "cocoa.h"

#include "mruby/variable.h"

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#include "ffi.h"

#define IGNORE_CLASSES \
    @"Protocol", \
    @"__IncompleteProtocol"


@implementation MrbObjectMap
@synthesize mrb_obj;
@end

cocoa_st_index_t hash_voidp(void *key)
{
    return (cocoa_st_index_t)key;
}

int hash_voidp_compare(void *x, void *y)
{
    return x != y;
}

const struct cocoa_st_hash_type hashtype_voidp = {
    hash_voidp_compare,
    hash_voidp,
};

static IMP swizzled_release_imp = NULL;
static SEL release_sel;
static SEL swizzled_sel;
static cocoa_st_table *tbl;

static int ignore_classnames_count = 0;
static Class* ignore_classes = NULL;


static
void swizzle(Class c, SEL orig, SEL patch)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method patchMethod = class_getInstanceMethod(c, patch);
    
    BOOL added = class_addMethod(c, orig,
                                 method_getImplementation(patchMethod),
                                 method_getTypeEncoding(patchMethod));
    
    if (added) {
        class_replaceMethod(c, patch,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
        return;
    }
    
    method_exchangeImplementations(origMethod, patchMethod);
}


static
bool processing_swizzled_release = false;

void
cocoa_swizzle_release_binding(ffi_cif *cif, void *ret, void **args,  void *original_release)
{
    id self = *(void**)args[0];

    if(swizzled_release_imp == NULL) {
        return; // Intializing
    }

    if(!processing_swizzled_release) {
        processing_swizzled_release = true;
        if([self retainCount] == 2) {
            for(int i = 0; i < cocoa_vm_count; ++i) {
                mrb_state *mrb = cocoa_mrb_states[i];
                MrbObjectMap *assoc = objc_getAssociatedObject(self, cocoa_state(mrb)->object_association_key);
                if(assoc) {
                    mrb_value keeper = mrb_gv_get(mrb, cocoa_state(mrb)->sym_obj_holder);
                    mrb_value mrb_obj = assoc.mrb_obj;
                    mrb_funcall_argv(mrb, keeper, cocoa_state(mrb)->sym_delete, 1, &mrb_obj);
                }
            }
        }
    }
    
    // call original release method
    void (*original_release_)(id self, SEL _cmd, ...) = original_release;
    original_release_(self, *(void**)args[1]);
    
    processing_swizzled_release = false;
}


int cocoa_swizzle_release(id obj)
{
    Class klass = object_getClass(obj);
    for(int i = 0; i < ignore_classnames_count; ++i) {
        if(ignore_classes[i] == klass) {
            return 0;
        }
    }

    Method release_method = class_getInstanceMethod(klass, release_sel);
    IMP obj_release = method_getImplementation(release_method);
    
    // release isn't NSObject#release
    if(obj_release != swizzled_release_imp) {
        // swizzle release method
        cocoa_st_data_t result;
        if(!cocoa_st_lookup(tbl, (cocoa_st_data_t)&obj_release, &result)) {
            // NSLog(@"cocoa_swizzle_release=%@, %p", klass, obj_release);
            void *closure_pointer = NULL;
            ffi_closure *closure = ffi_closure_alloc(sizeof(ffi_closure) + sizeof(void*), &closure_pointer);
            ffi_cif *cif = malloc(sizeof(ffi_cif));
    
            ffi_type **arg_ffi_types = malloc(sizeof(ffi_type*) * 2);
            arg_ffi_types[0] = &ffi_type_pointer;
            arg_ffi_types[1] = &ffi_type_pointer;

            if (!closure ||
                ffi_prep_cif(cif, FFI_DEFAULT_ABI, 2, &ffi_type_void, arg_ffi_types) != FFI_OK ||
                ffi_prep_closure_loc(closure, cif, cocoa_swizzle_release_binding, obj_release, closure_pointer) != FFI_OK) {
                assert(false);
            }

            class_addMethod(klass, swizzled_sel, closure_pointer, "@:");            
            swizzle(klass, release_sel, swizzled_sel);
            cocoa_st_insert(tbl, (cocoa_st_data_t)&obj_release, (cocoa_st_data_t)klass);
        }
    }

    return 1;
}


void init_objc_hook()
{
    if(ignore_classes == NULL) {
        NSArray* ignore_classenames = @[IGNORE_CLASSES];
        ignore_classnames_count = [ignore_classenames count];
        ignore_classes = malloc(sizeof(Class*) * ignore_classnames_count);
        int i = 0;
        for (NSString* str in ignore_classenames) {
            ignore_classes[i] = (NSClassFromString(str));
            ++i;
        }
    }

    if(swizzled_release_imp == NULL) {
        tbl = cocoa_st_init_table(&hashtype_voidp);

        swizzled_sel = @selector(mruby_cocoa_release);
        release_sel = @selector(release);

        id nsobj = [[[NSObject alloc] init] autorelease];
        cocoa_swizzle_release(nsobj);

        Class klass = [nsobj class];
        Method release_method = class_getInstanceMethod(klass, release_sel);
        swizzled_release_imp = method_getImplementation(release_method);
    }
}




