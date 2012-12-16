//
//  cfunc_block.m
//  MobiRuby
//
//  Created by Yuichiro MASUI on 7/3/12.
//  Copyright (c) 2012 Yuichiro MASUI. All rights reserved.
//

#include "cocoa_block.h"
#include "cfunc_pointer.h"
#include "cfunc_closure.h"

#import <Foundation/Foundation.h>


static void
objc_block_copy_helper(void *dst, void *src)
{
    // NO OP
}

static void
objc_block_dispose_helper(void *src)
{
    // NO OP
}

struct objc_block_literal {
    void *isa; // initialized to &_NSConcreteStackBlock or &_NSConcreteGlobalBlock
    int flags; // 0
    int reserved;  // 0
    void (*invoke)(void *, ...);
    void *descriptor; // NULL
};

static struct objc_block_descriptor {
    unsigned long int reserved;
    unsigned long int size;
    void (*copy_helper)(void *dst, void *src);
    void (*dispose_helper)(void *src);
}
objc_block_descriptor = {
    .reserved = 0,
    .size = sizeof(struct objc_block_literal),
    .copy_helper = &objc_block_copy_helper,
    .dispose_helper = &objc_block_dispose_helper
}; 


static mrb_value
cocoa_block_addr(mrb_state *mrb, mrb_value self)
{
    struct objc_block_literal **bl = malloc(sizeof(struct objc_block_literal *));
    *bl = malloc(sizeof(struct objc_block_literal));
    (*bl)->isa = &_NSConcreteGlobalBlock;
    (*bl)->flags = 0;
    (*bl)->reserved = 0;
    (*bl)->invoke = cfunc_pointer_ptr(self);
    (*bl)->descriptor = &objc_block_descriptor;

    return cfunc_pointer_new_with_pointer(mrb, bl, false); // todo:いつ解放するの？
}


/*
 * internal function
 */
static void
cocoa_block_destructor(mrb_state *mrb, void *p)
{
    // TODO: pointerの解放をどうする？
    // if(((struct cfunc_block_data*)p)->autofree) {
    //    free(((struct cfunc_block_data*)p)->pointer);
    // }
    free(p);
}


// todo デストラクタを正しく設定。ここでclosureのデストラクタも呼ばれるの？
/*
 * internal data
 */
const struct mrb_data_type cfunc_block_data_type = {
    "cfunc_block", cocoa_block_destructor,
};


/*
 * initialize function
 */
void
init_cocoa_block(mrb_state *mrb, struct RClass* module)
{
    struct RClass *block_class = mrb_define_class_under(mrb, module, "Block", cfunc_state(mrb)->closure_class);
    cocoa_state(mrb)->block_class = block_class;

    mrb_define_method(mrb, block_class, "addr", cocoa_block_addr, ARGS_NONE());
}
