//
//  initialize mruby-cocoa
// 
//  See Copyright Notice in cocoa.h
//

#include "cocoa.h"
#include "cocoa_object.h"
#include "cocoa_block.h"
#include "cocoa_obj_hook.h"
#include "cocoa_bridgesupport.h"
#include "cocoa_type.h"

#include "mruby.h"
#include "mruby/class.h"
#include "mruby/proc.h"
#include "mruby/value.h"
#include "mruby/dump.h"
#include "cfunc_pointer.h"

#import <Foundation/Foundation.h>
#include <setjmp.h>
#include "ffi.h"

#define MAX_COCOA_MRB_STATE_COUNT 256

mrb_state **cocoa_mrb_states = NULL;
NSAutoreleasePool **cocoa_autorelease_pool = NULL;
int cocoa_vm_count = 0;


mrb_value
cocoa_mrb_state(mrb_state *mrb, mrb_value klass)
{
    return cfunc_pointer_new_with_pointer(mrb, mrb, false);
}

void
set_cocoa_state(mrb_state* mrb, struct cocoa_state *state)
{
    mrb_value mstate = mrb_voidp_value(state);
    struct RClass* klass = (struct RClass*)mrb_object(mrb_vm_const_get(mrb, mrb_intern(mrb, "Cocoa")));
    mrb_mod_cv_set(mrb, klass, mrb_intern(mrb, "cocoa_state"), mstate);
}

void
mrb_mruby_cocoa_gem_init(mrb_state *mrb)
{
    if(cocoa_vm_count >= MAX_COCOA_MRB_STATE_COUNT - 1) {
        puts("Too much open vm"); // TODO
    }

    if(cocoa_mrb_states == NULL) {
        cocoa_autorelease_pool = mrb_malloc(mrb, sizeof(NSAutoreleasePool *) * MAX_COCOA_MRB_STATE_COUNT);
        cocoa_mrb_states = mrb_malloc(mrb, sizeof(mrb_state *) * MAX_COCOA_MRB_STATE_COUNT);
        for(int i = 0; i < MAX_COCOA_MRB_STATE_COUNT; ++i) {
            cocoa_mrb_states[i] = NULL;
            cocoa_autorelease_pool[i] = NULL;
        }
        cocoa_vm_count = 0;
    }
    cocoa_autorelease_pool[cocoa_vm_count] = [[NSAutoreleasePool alloc] init];
    cocoa_mrb_states[cocoa_vm_count++] = mrb;

    struct RClass *ns = mrb_define_module(mrb, "Cocoa");

    struct cocoa_state *cs = mrb_malloc(mrb, sizeof(struct cocoa_state));
    cs->namespace = ns;
    set_cocoa_state(mrb, cs);

    init_objc_hook();
    init_cocoa_module_type(mrb, ns);
    init_cocoa_object(mrb, ns);
    init_cocoa_block(mrb, ns);
    init_cocoa_bridge_support(mrb, ns);
}

void
mrb_mruby_cocoa_gem_final(mrb_state *mrb)
{
    int i = 0;
    while(cocoa_mrb_states[i] != mrb) {
        ++i;
    }
    [cocoa_autorelease_pool[i] release];

    memmove(&cocoa_autorelease_pool[i+1], &cocoa_autorelease_pool[i], sizeof(NSAutoreleasePool *) * (MAX_COCOA_MRB_STATE_COUNT - i - 1));
    memmove(&cocoa_mrb_states[i+1], &cocoa_mrb_states[i], sizeof(mrb_state *) * (MAX_COCOA_MRB_STATE_COUNT - i - 1));
    --cocoa_vm_count;
}
