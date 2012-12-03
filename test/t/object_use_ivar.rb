def _S(str)
  Cocoa::NSString._stringWithUTF8String(str)
end

# instance variable - int
test1 = Cocoa::MobiCocoaTest1._alloc._init
ivar_i = test1.ivar[:i]
assert_equal 10, ivar_i.to_i

result = test1._set_i(CFunc::Int(-128))
assert_equal -128, test1.ivar[:i].to_i

test1.ivar[:i] = -256
assert_equal -256, test1.ivar[:i].to_i

# instance variable - object
obj = test1.ivar[:obj]
assert_equal "Test", obj._UTF8String.to_s

test1.ivar[:obj] = _S("Test123")
obj = test1.ivar[:obj]
assert_equal "Test123", obj._UTF8String.to_s


############
# BEGIN C

@interface MobiCocoaTest1 : NSObject {
    int i;
    id obj;
}
@end


@implementation MobiCocoaTest1

- (id)init {
    if(self = [super init]) {
        i = 10;
        obj = @"Test";
    }

    return self;
}

- (void)set_i:(int)value
{
    i = value;
}

@end
