Cocoa::Protocol :Proto1 do
  define CFunc::Void, :foo1
  define_class CFunc::Void, :foo1_class
  
  optional
  define CFunc::Void, :foo2
  define_class CFunc::Void, :foo2_class

  required
  define CFunc::Void, :foo3
end

proto1 = CFunc::call(Cocoa::Object, "objc_getProtocol", "Proto1")


class Objc_method_description < CFunc::Struct
  define CFunc::Pointer, :sel,
    CFunc::Pointer, :types
end

outCount = CFunc::Int.new


# struct objc_method_description *protocol_copyMethodDescriptionList(Protocol *p, BOOL isRequiredMethod, BOOL isInstanceMethod, unsigned int *outCount)
required_instance_methods = CFunc::call(CFunc::Pointer(Objc_method_description), "protocol_copyMethodDescriptionList", proto1, true, true, outCount.addr)
assert !required_instance_methods.is_null?
assert_equal 2, outCount.to_i
assert_equal "foo1", required_instance_methods[0][:sel].to_s
assert_equal "v:@", required_instance_methods[0][:types].to_s
assert_equal "foo3", required_instance_methods[1][:sel].to_s
assert_equal "v:@", required_instance_methods[1][:types].to_s

required_class_methods = CFunc::call(CFunc::Pointer(Objc_method_description), "protocol_copyMethodDescriptionList", proto1, true, false, outCount.addr)
assert !required_class_methods.is_null?
assert_equal 1, outCount.to_i
assert_equal "foo1_class", required_class_methods[0][:sel].to_s
assert_equal "v:@", required_class_methods[0][:types].to_s

optional_instance_methods = CFunc::call(CFunc::Pointer(Objc_method_description), "protocol_copyMethodDescriptionList", proto1, false, true, outCount.addr)
assert !optional_instance_methods.is_null?
assert_equal 1, outCount.to_i
assert_equal "foo2", optional_instance_methods[0][:sel].to_s
assert_equal "v:@", optional_instance_methods[0][:types].to_s

optional_class_methods = CFunc::call(CFunc::Pointer(Objc_method_description), "protocol_copyMethodDescriptionList", proto1, false, false, outCount.addr)
assert !optional_class_methods.is_null?
assert_equal 1, outCount.to_i
assert_equal "foo2_class", optional_class_methods[0][:sel].to_s
assert_equal "v:@", optional_class_methods[0][:types].to_s




Cocoa::Protocol(:Proto2, [:Proto1]) do
  define CFunc::Void, :foo1a
  define_class CFunc::Void, :foo1a_class
  
  optional
  define CFunc::Void, :foo2a
  define_class CFunc::Void, :foo2a_class

  required
  define CFunc::Void, :foo3a
end

proto2 = CFunc::call(Cocoa::Object, "objc_getProtocol", "Proto2")

assert 1, CFunc::call(CFunc::Int, "protocol_conformsToProtocol", proto2, proto1).to_i


required_instance_methods = CFunc::call(CFunc::Pointer(Objc_method_description), "protocol_copyMethodDescriptionList", proto2, true, true, outCount.addr)
assert !required_instance_methods.is_null?
assert_equal 2, outCount.to_i
assert_equal "foo1a", required_instance_methods[0][:sel].to_s
assert_equal "v:@", required_instance_methods[0][:types].to_s
assert_equal "foo3a", required_instance_methods[1][:sel].to_s
assert_equal "v:@", required_instance_methods[1][:types].to_s

required_class_methods = CFunc::call(CFunc::Pointer(Objc_method_description), "protocol_copyMethodDescriptionList", proto2, true, false, outCount.addr)
assert !required_class_methods.is_null?
assert_equal 1, outCount.to_i
assert_equal "foo1a_class", required_class_methods[0][:sel].to_s
assert_equal "v:@", required_class_methods[0][:types].to_s

optional_instance_methods = CFunc::call(CFunc::Pointer(Objc_method_description), "protocol_copyMethodDescriptionList", proto2, false, true, outCount.addr)
assert !optional_instance_methods.is_null?
assert_equal 1, outCount.to_i
assert_equal "foo2a", optional_instance_methods[0][:sel].to_s
assert_equal "v:@", optional_instance_methods[0][:types].to_s

optional_class_methods = CFunc::call(CFunc::Pointer(Objc_method_description), "protocol_copyMethodDescriptionList", proto2, false, false, outCount.addr)
assert !optional_class_methods.is_null?
assert_equal 1, outCount.to_i
assert_equal "foo2a_class", optional_class_methods[0][:sel].to_s
assert_equal "v:@", optional_class_methods[0][:types].to_s
