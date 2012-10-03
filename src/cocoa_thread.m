//
//  cocoa_types.m
//  MobiRuby
//
//  Created by Yuichiro MASUI on 4/16/12.
//  Copyright (c) 2012 Yuichiro MASUI. All rights reserved.
//

#import "cocoa_thread.h"
#include "pthread.h"

void init_cocoa_thread(mrb_state *mrb, struct RClass* module)
{
    cocoa_state(mrb)->thread = pthread_self();
    NSLog(@"Current thread=%p", cocoa_state(mrb)->thread);
}
