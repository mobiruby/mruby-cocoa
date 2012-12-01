def _S(str)
  Cocoa::NSString._stringWithUTF8String(str)
end

# create instance
test1 = Cocoa::MobiCocoaTest1._alloc._init

# get property
result = test1[:prop1]
assert_equal "PROP1", result._UTF8String.to_s

# get property
test1[:prop2] = _S("PROP2")
result = test1[:prop2]
assert_equal "PROP2", result._UTF8String.to_s

# update propperty
test1[:prop2] = _S("PROP2_")
result = test1[:prop2]
assert_equal "PROP2_", result._UTF8String.to_s

# get struct value from property
result = test1[:struct1]
assert_equal 100, result[:i]


############
# BEGIN C
#include <objc/runtime.h>

struct BridgeSupportStructTable struct_table[] = {
    {.name = "MobiCocoaStruct1", .definition = "i:i"},
    {.name = NULL, .definition = NULL}
};

struct BridgeSupportConstTable const_table[] = {
    {.name = NULL, .type=NULL, .value = NULL}
};

struct BridgeSupportEnumTable enum_table[] = {
    {.name = NULL}
};

void
load_rubyvm(mrb_state *mrb) {
    load_cocoa_bridgesupport(mrb, struct_table, const_table, enum_table);  
}

struct MobiCocoaStruct1 {
    int i;
};

@interface MobiCocoaTest1 : NSObject {
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


- (id)init {
    if(self = [super init]) {
        struct1.i = 100;
    }

    return self;
}

- (NSString*)prop1_
{
    return @"PROP1";
}

@end
