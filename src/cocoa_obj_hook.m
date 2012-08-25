//
//  hook objective-c object
//
//  See Copyright Notice in cocoa.h
//

#include "cocoa_obj_hook.h"
#include "cocoa.h"

#include "mruby/variable.h"

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <objc/runtime.h>



@implementation MrbObjectMap
@synthesize mrb_obj;
@end

static
IMP original_release = NULL;

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
id release_mobiruby(id self, SEL _cmd, ...)
{
    if([self retainCount] <= 2) {
        for(int i = 0; i < cocoa_vm_count; ++i) {
            mrb_state *mrb = cocoa_mrb_states[i];
            MrbObjectMap *assoc = objc_getAssociatedObject(self, cocoa_state(mrb)->object_association_key);
            if(assoc) {
                NSLog(@"REMOVE ASSOC! = %@", self);
                mrb_value keeper = mrb_gv_get(mrb, cocoa_state(mrb)->sym_obj_holder);
                mrb_value mrb_obj = assoc.mrb_obj;
                mrb_funcall_argv(mrb, keeper, cocoa_state(mrb)->sym_delete, 1, &mrb_obj);
            }
        }
    }
    original_release(self, _cmd);
    
    return NULL;
}

void init_objc_hook()
{
    if(original_release == NULL) {
        Class c = [NSObject class];
        const SEL release_sel  = @selector(release);
        const SEL swizzled_sel = @selector(release_mobiruby);
        Method release_method = class_getInstanceMethod(c, release_sel);
        original_release = method_getImplementation(release_method);
        
        class_addMethod(c, swizzled_sel, release_mobiruby, "@:");
        swizzle(c, release_sel, swizzled_sel);
    }
}

