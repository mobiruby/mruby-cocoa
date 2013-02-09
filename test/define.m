#import "cocoa.h"
#import "Foundation/Foundation.h"
#include <objc/runtime.h>
#include <objc/message.h>

struct BridgeSupportStructTable struct_table[] = {
    {.name = "MobiCocoaStruct1", .definition = "i:i"},
    {.name = "MobiCocoaStruct2", .definition = "i1:i:i2:i"},
    {.name = NULL, .definition = NULL}
};

const double test1 = 12345;

struct BridgeSupportConstTable const_table[] = {
    {.name = "test1", .type = "d", .value = (void*)&test1},
    {.name = NULL, .type=NULL, .value = NULL}
};

struct BridgeSupportEnumTable enum_table[] = {
    {.name="enum1", .value={"\001\000\000\000\000\000\000\000"}, .type='s'},
    {.name="enum2", .value={"\000\000\000\000\000\000\320?"}, .type='d'}, // 0.25
    {.name = NULL}
};

struct MobiCocoaStruct1 {
    int i;
};


@interface MobiCocoaTest1 : NSObject {
    int i;
    id obj;
    NSString *prop2;
    struct MobiCocoaStruct1 struct1;
}
@property(retain, getter=prop1_, readonly) NSString *prop1;
@property(retain) NSString *prop2;
@property(assign) struct MobiCocoaStruct1 struct1;
@end


@implementation MobiCocoaTest1

@dynamic prop1;
@synthesize prop2, struct1;

+ (NSString*)classMethod1
{
    return @"classMethod1Test";
}

- (id)init {
    if(self = [super init]) {
        i = 10;
        struct1.i = 100;
        obj = @"Test";
    }

    return self;
}

- (void)set_i:(int)value
{
    i = value;
}

- (NSString*)prop1_
{
    return @"PROP1";
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


int MobiCocoaTest2Ruby1(id obj)
{
    return (int)objc_msgSend(obj, sel_getUid("ruby_method1"));
}

int MobiCocoaTest2Ruby2(id obj)
{
    return (int)objc_msgSend(obj, sel_getUid("ruby_method2:"), 3);
}

int MobiCocoaTest2Ruby3(id obj)
{
    return (int)objc_msgSend([obj class], sel_getUid("ruby_method3:"), 3);
}

