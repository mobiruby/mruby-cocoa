//
//  BridgeSupport loader
//
//  See Copyright Notice in cocoa.h
//

#include "cocoa_bridgesupport.h"
#include "cocoa.h"
#include "cfunc.h"
#include "cfunc_struct.h"

#include "mruby/variable.h"

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <objc/runtime.h>

struct StructTable
{
    const char *name;
    const char *definition;
}
struct_table[] = {
    {.name = "CGPoint", .definition = "x:f:y:f"},
    {.name = "CGSize", .definition = "width:f:height:f"},
    {.name = "CGRect", .definition = "origin:{CGPoint}:size:{CGSize}"},
    {.name = "MobiCocoaStruct1", .definition = "i:i:d:d:str:*:obj:@:iptr:^i"},
    {.name = NULL, .definition = NULL}
};

const char* cocoa_bridgesupport_struct_lookup(mrb_state *mrb, const char *name)
{
    struct StructTable *cur = struct_table;
    while(cur->name) {
        if(strcmp(name, cur->name)==0) {
            return cur->definition;
        }
        ++cur;
    }
    return NULL;
}


void
cocoa_bridgesupport_load(mrb_state *mrb)
{
    
}
