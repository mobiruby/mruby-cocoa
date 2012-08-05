//
//  initialize mruby-cocoa
// 
//  See Copyright Notice in cocoa.h
//

#include "cocoa.h"
#include "cocoa_object.h"
#include "cocoa_block.h"
#include "cocoa_obj_hook.h"

#include "mruby.h"
#include "mruby/class.h"

#import <Foundation/Foundation.h>

size_t cocoa_state_offset = 0;

// generate from mrb/cfunc_rb.rb
void
init_cocoa(mrb_state *mrb);

#define MAX_COCOA_MRB_STATE_COUNT 256

mrb_state **cocoa_mrb_states = NULL;
int cocoa_vm_count = 0;

void init_cocoa_module(mrb_state *mrb)
{
    if(cocoa_vm_count >= MAX_COCOA_MRB_STATE_COUNT - 1) {
        puts("Too much open vm"); // TODO
    }

    if(cocoa_mrb_states==NULL) {
        cocoa_mrb_states = malloc(sizeof(mrb_state *) * MAX_COCOA_MRB_STATE_COUNT);
        for(int i = 0; i < MAX_COCOA_MRB_STATE_COUNT; ++i) {
            cocoa_mrb_states[i] = NULL;
        }
    }
    cocoa_mrb_states[cocoa_vm_count++] = mrb;

    struct RClass *ns = mrb_define_module(mrb, "Cocoa");
    cocoa_state(mrb)->namespace = ns;

    init_objc_hook();
    init_cocoa_object(mrb, ns);
    init_cocoa_block(mrb, ns);
    init_cocoa(mrb);
}

void close_cocoa_module(mrb_state *mrb)
{
    int i = 0;
    while(cocoa_mrb_states[i] != mrb) {
        ++i;
    }
    memmove(cocoa_mrb_states[i+1], cocoa_mrb_states[i], sizeof(mrb_state *) * (MAX_COCOA_MRB_STATE_COUNT - i - 1));
    --cocoa_vm_count;
}
