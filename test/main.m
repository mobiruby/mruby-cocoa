#include "cocoa.h"
#include "cfunc.h"

#import <Foundation/Foundation.h>


struct mrb_state_ud {
    struct cfunc_state cfunc_state;
    struct cocoa_state cocoa_state;
};


void
init_unittest(mrb_state *mrb);

void
init_cocoa_test(mrb_state *mrb);


int main(int argc, char *argv[])
{
    mrb_state *mrb = mrb_open();
    mrb->ud = malloc(sizeof(struct mrb_state_ud));

    cfunc_state_offset = cfunc_offsetof(struct mrb_state_ud, cfunc_state);
    init_cfunc_module(mrb);

    cocoa_state_offset = cocoa_offsetof(struct mrb_state_ud, cocoa_state);
    init_cocoa_module(mrb);

    init_unittest(mrb);
    if (mrb->exc) {
        mrb_p(mrb, mrb_obj_value(mrb->exc));
    }

    init_cocoa_test(mrb);
    if (mrb->exc) {
        mrb_p(mrb, mrb_obj_value(mrb->exc));
    }
}

struct MobiCocoaStruct1 {
    int i;
    double d;
    const char* str;
    id obj;
    int *iptr;
};

@interface MobiCocoaTest1 : NSObject {
    NSString *prop2;
    struct MobiCocoaStruct1 struct1;
}
@property(retain,getter=prop1_,readonly) NSString *prop1;
@property(retain) NSString *prop2;
@property(assign) struct MobiCocoaStruct1 struct1;
@end


@implementation MobiCocoaTest1

- (struct MobiCocoaStruct1)struct1
{
    struct1.i = 100;
    return struct1;
}

- (void)setStruct1:(struct MobiCocoaStruct1)str
{
    struct1 = str;
}

- (NSString*)prop1_
{
    return @"PROP1_";
}

- (NSString*)prop1
{
    return @"PROP1";
}

- (NSString*)prop2
{
    return prop2;
}

- (void)setProp2:(NSString*)str
{
    [prop2 release];
    prop2 = [str retain];
}

+ (NSString*)classMethod1
{
    return @"classMethod1Test";
}

- (NSString*)intToString:(int)value
{
    return [NSString stringWithFormat: @"value=%d", value];
}

- (NSString*)uint16ToString:(unsigned short)value
{
    return [NSString stringWithFormat: @"value=%hu", value];
}

- (int)testBlocks1:(int (^)(int))block
{
    int result = block(2) * block(3);
    return result;
}

- (int)testBlocks2:(int (^)(int))block
{
    int (^myBlock)(int) = ^(int num) {
        return block(1+num) * block(2+num);
    };
    int result = myBlock(1);
    return result;
}
@end

