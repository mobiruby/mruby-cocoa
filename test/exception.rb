mobiruby_test "Cocoa::catch exception" do
  class Cocoa::MobiCocoaExceptionTest < Cocoa::NSObject
    define_class CFunc::Void, :raise_exception do
      Cocoa::NSException._raise Cocoa::NSString._stringWithUTF8String("TestException"), :format, Cocoa::NSString._stringWithUTF8String("Test")
    end
  end
  Cocoa::MobiCocoaExceptionTest.register

  assert_raise(ObjCException) do
    Cocoa::MobiCocoaExceptionTest._raise_exception
  end
end
