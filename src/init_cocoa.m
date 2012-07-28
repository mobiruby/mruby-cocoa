//
//  initialize mruby-cocoa
// 
//  See Copyright Notice in cocoa.h
//

#include "cocoa.h"

#include "mruby.h"
#include "mruby/class.h"

#import <Foundation/Foundation.h>

size_t cocoa_state_offset = 0;

// generate from mrb/cfunc_rb.rb
void
init_cocoa_rb(mrb_state *mrb);


void init_cocoa_module(mrb_state *mrb)
{
    struct RClass *ns = mrb_define_module(mrb, "Cocoa");
    cocoa_state(mrb)->namespace = ns;

/*
    init_cfunc_type(mrb, ns);
    init_cfunc_pointer(mrb, ns);
    init_cfunc_struct(mrb, ns);
    init_cfunc_closure(mrb, ns);
    init_cfunc_call(mrb, ns);
    
    init_cocoa_rb(mrb);
*/
}
