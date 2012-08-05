//
//  hook objective-c object
//
//  See Copyright Notice in cocoa.h
//
#ifndef mruby_cocoa_obj_hook_h
#define mruby_cocoa_obj_hook_h

#include "mruby.h"
#include <stdbool.h>


@interface MrbObjectMap : NSObject {
    mrb_value mrb_obj;
    bool active;
}
@property (nonatomic, assign) mrb_value mrb_obj;
@property (nonatomic, assign) bool active;
@end

void init_objc_hook();

#endif
