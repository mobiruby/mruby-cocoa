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

#include "mruby.h"
#include "mruby/class.h"
#include "mruby/proc.h"
#include "mruby/dump.h"

#import <Foundation/Foundation.h>
#include <setjmp.h>
#include "ffi.h"

#ifdef USE_MRBC_DATA
extern const char mruby_data_cocoa[];
#endif

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

    if(cocoa_mrb_states == NULL) {
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
    init_cocoa_bridge_support(mrb);

#ifdef USE_MRBC_DATA
    int n = mrb_read_irep(mrb, mruby_data_cocoa);
    if (n >= 0) {
        mrb_irep *irep = mrb->irep[n];
        struct RProc *proc = mrb_proc_new(mrb, irep);
        proc->target_class = mrb->object_class;
        mrb_run(mrb, proc, mrb_nil_value());
    }
    else if (mrb->exc) {
        longjmp(*(jmp_buf*)mrb->jmp, 1);
    }
#else
    init_cocoa(mrb);
#endif

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
