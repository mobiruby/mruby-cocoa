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


@interface MrbObjectMap : NSObject {
    mrb_value mrb_obj;
    bool active;
}
@property (nonatomic, assign) mrb_value mrb_obj;
@property (nonatomic, assign) bool active;
@end

#endif
