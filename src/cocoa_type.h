//
//  cocoa_types.h
//  MobiRuby
//
//  Created by Yuichiro MASUI on 4/16/12.
//  Copyright (c) 2012 Yuichiro MASUI. All rights reserved.
//

#ifndef mruby_cocoa_types_h
#define mruby_cocoa_types_h

#include "cocoa.h"
#include "ffi.h"

struct cocoa_type_data {
    ffi_type *ffi;
};

mrb_value
objc_type_to_cfunc_type(mrb_state *mrb, const char* objc_type);

#endif
