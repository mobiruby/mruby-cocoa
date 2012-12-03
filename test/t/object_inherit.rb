class Cocoa::MobiCocoaTest2 < Cocoa::MobiCocoaTest1
  define CFunc::Int, :ruby_method1 do
    1
  end

  define CFunc::Int, :ruby_method2, CFunc::Int do |i|
    i.value ** 2
  end

  define_class CFunc::Int, :ruby_method3, CFunc::Int do |i|
    i.value ** 3
  end
end
  
# call rubymethod1
test2 = Cocoa::MobiCocoaTest2._alloc._init
assert test2.is_a?(Cocoa::Object)
assert_equal 1, test2._ruby_method1.to_i

# call rubymethod1 from C
result = CFunc::call(CFunc::Int, "MobiCocoaTest2Ruby1", test2)
assert_equal 1, result.to_i

# call rubymethod2
test2 = Cocoa::MobiCocoaTest2._alloc._init
assert test2.is_a?(Cocoa::Object)
assert_equal 9, test2._ruby_method2(3).to_i

# call rubymethod2 from C
result = CFunc::call(CFunc::Int, "MobiCocoaTest2Ruby2", test2)
assert_equal 9, result.to_i

# call class method
assert_equal 27, Cocoa::MobiCocoaTest2._ruby_method3(3).to_i

# call class method from C
result = CFunc::call(CFunc::Int, "MobiCocoaTest2Ruby3", test2)
assert_equal 27, result.to_i

# call parent class method
result2 = Cocoa::MobiCocoaTest2._classMethod1
assert result2.is_a?(Cocoa::Object)
assert_equal "classMethod1Test", result2._UTF8String.to_s

# call instance parent method
test2 = Cocoa::MobiCocoaTest2._alloc._init
result2 = test2._intToString(CFunc::Int(10))
assert_equal "value=10", result2._UTF8String.to_s


############
# BEGIN C
#import "objc/runtime.h"

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
