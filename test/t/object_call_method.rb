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

@interface MobiCocoaTest1 : NSObject
@end


@implementation MobiCocoaTest1

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
