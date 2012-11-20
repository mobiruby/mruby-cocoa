nsstr = Cocoa::NSString._stringWithUTF8String("string")

assert nsstr.is_a?(Cocoa::Object)
assert nsstr.is_kind_of?("NSString")
assert nsstr.is_kind_of?("NSObject")
assert !nsstr.is_kind_of?("NSNumber")
assert_equal 6, nsstr._length.value
