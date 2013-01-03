class Cocoa::MobiCocoaTest1 < Cocoa::NSObject
  ivar :i, CFunc::Int
  ivar :obj, Cocoa::Object
end
Cocoa::MobiCocoaTest1.register


def _S(str)
  Cocoa::NSString._stringWithUTF8String(str)
end

# instance variable - int
test1 = Cocoa::MobiCocoaTest1._alloc._init

test1.ivar[:i] = -256
assert_equal -256, test1.ivar[:i].to_i

# instance variable - object
test1.ivar[:obj] = _S("Test123")
obj = test1.ivar[:obj]
assert_equal "Test123", obj._UTF8String.to_s
