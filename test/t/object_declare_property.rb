class Cocoa::MobiCocoaTest1 < Cocoa::NSObject 
  attr_accessor :prop1, :prop2, :prop3, :prop3_, :prop4, :prop4_
  property :prop1, CFunc::Int
  property :prop2, Cocoa::Object
  property :prop3, Cocoa::Object, :ivar => :prop3_
  property :prop4, Cocoa::Object, :getter => 'get_prop4', :setter => 'set_prop4:'
  
  define Cocoa::Object, :get_prop4 do
    _S(@prop4_ || "none")
  end
  
  define CFunc::Void, :set_prop4, Cocoa::Object do |str|
    if str.is_a?(Cocoa::Object)
      @prop4_ = str._UTF8String.to_s
    else
      @prop4_ = str.to_s
    end
  end
end

def _S(str)
  Cocoa::NSString._stringWithUTF8String(str)
end

# create instance
test1 = Cocoa::MobiCocoaTest1._alloc._init

if false # todo
# get int property
test1.prop1 = 123
result = test1[:prop1]
assert result.is_a?(CFunc::Int)
assert_equal 123, result.to_i

# update int propperty
test1[:prop1] = 456
assert result.is_a?(CFunc::Int)
assert_equal 456, result.to_i

# update int propperty
test1[:prop1] = CFunc::Int(789)
assert result.is_a?(CFunc::Int)
assert_equal 789, result.to_i


# get object property
test1.prop2 = _S("PROP2")
result = test1[:prop2]
assert result.is_a?(Cocoa::Object)
assert_equal "PROP2", result._UTF8String.to_s

# update object propperty
test1[:prop2] = _S("PROP2_")
result = test1[:prop2]
assert_equal "PROP2_", result._UTF8String.to_s


# get object property
test1.prop3_ = _S("PROP3")
result = test1[:prop3]
assert result.is_a?(Cocoa::Object)
assert_equal "PROP3", result._UTF8String.to_s

# update object propperty
test1[:prop3] = _S("PROP3_")
result = test1[:prop3]
assert_equal "PROP3_", result._UTF8String.to_s
assert_equal "PROP3_", test1.prop3_._UTF8String.to_s
assert_equal nil, test1.prop3


# get object property
result = test1[:prop4]
assert result.is_a?(Cocoa::Object)
assert_equal "none", result._UTF8String.to_s
assert_equal nil, test1.prop4_
assert_equal nil, test1.prop4

# update object propperty
test1[:prop4] = "PROP4"
result = test1[:prop4]
assert_equal "PROP4_", result._UTF8String.to_s
assert_equal "PROP4_", test1.prop4_
assert_equal nil, test1.prop4
end