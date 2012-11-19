
# call class method
result1 = Cocoa::MobiCocoaTest1._classMethod1
assert result1.is_a?(Cocoa::Object)
assert_equal "classMethod1Test", result1._UTF8String.to_s

# create instance
test1 = Cocoa::MobiCocoaTest1._alloc._init
assert test1.is_a?(Cocoa::Object)

# call instance method
result = test1._intToString(CFunc::Int(10))
assert_equal "value=10", result._UTF8String.to_s

# call instance method with mruby value
result = test1._uint16ToString(CFunc::SInt8(-1))
assert_equal "value=255", result._UTF8String.to_s

# call instance method with ruby value
result = test1._uint16ToString(-1)
assert_equal "value=65535", result._UTF8String.to_s

# get prop
result = test1[:prop1]
assert_equal "PROP1_", result._UTF8String.to_s

# get prop
val = Cocoa::NSString._stringWithUTF8String("PROP2")
test1[:prop2] = val
result = test1[:prop2]
assert_equal "PROP2", result._UTF8String.to_s

test1[:prop2] = Cocoa::NSString._stringWithUTF8String("PROP2_")
result = test1[:prop2]
assert_equal "PROP2_", result._UTF8String.to_s

# get struct
result = test1[:struct1]
assert_equal 100, result[:i]

# call with block
block = Cocoa::Block.new(CFunc::Int, [CFunc::Int]) { |i|
  i.value + 1
}
test1 = Cocoa::MobiCocoaTest1._alloc._init
result = test1._testBlocks1 block
assert_equal 12, result.value

# call with block
block = Cocoa::Block.new(CFunc::Int, [CFunc::Int]) { |i|
  i.value + 1
}
test1 = Cocoa::MobiCocoaTest1._alloc._init
result = test1._testBlocks2 block
assert_equal 12, result.value


############
# BEGIN C

struct BridgeSupportStructTable struct_table[] = {
    {.name = "CGPoint", .definition = "x:f:y:f"},
    {.name = "CGSize", .definition = "width:f:height:f"},
    {.name = "CGRect", .definition = "origin:{CGPoint}:size:{CGSize}"},
    {.name = "MobiCocoaStruct1", .definition = "i:i:d:d:str:*:obj:@:iptr:^i"},
    {.name = NULL, .definition = NULL}
};

struct BridgeSupportConstTable const_table[] = {
    {.name = "kCFAbsoluteTimeIntervalSince1904", .type = "d", .value = &kCFAbsoluteTimeIntervalSince1904},
    {.name = "kCFNumberFormatterCurrencyCode", .type = "^{__CFString=}", .value = &kCFNumberFormatterCurrencyCode},
    {.name = "kCFTypeArrayCallBacks", .type = "{_CFArrayCallBacks=i^?^?^?^?}", .value = &kCFTypeArrayCallBacks},
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
    double d;
    const char* str;
    id obj;
    int *iptr;
};

struct MobiCocoaStruct2 {
    int i1, i2;
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