//
//  Cocoa::Object
//
//  See Copyright Notice in cocoa.h
//

#ifndef mruby_cocoa_object_h
#define mruby_cocoa_object_h

#include "cocoa.h"
#include "cfunc_type.h"

#include <stdbool.h>
#import <Foundation/Foundation.h>

struct cocoa_object_data {
    CFUNC_TYPE_HEADER;
    mrb_state *mrb;
    bool autorelease;
};

void init_cocoa_object(mrb_state *mrb, struct RClass* module);

#endif
