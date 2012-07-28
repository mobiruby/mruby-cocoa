//
//  initialize mruby-cocoa
// 
//  See Copyright Notice in cocoa.h
//

#include "cocoa.h"
#include "cocoa_object.h"
#include "cocoa_block.h"

#include "mruby.h"
#include "mruby/class.h"

#import <Foundation/Foundation.h>

size_t cocoa_state_offset = 0;

// generate from mrb/cfunc_rb.rb
void
init_cocoa(mrb_state *mrb);


void init_cocoa_module(mrb_state *mrb)
{
    struct RClass *ns = mrb_define_module(mrb, "Cocoa");
    cocoa_state(mrb)->namespace = ns;

    init_cocoa_object(mrb, ns);
    init_cocoa_block(mrb, ns);
    init_cocoa(mrb);
}
