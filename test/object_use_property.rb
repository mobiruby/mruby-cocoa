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
assert_equal 10, result[:i]
