
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

# call rubymethod
test2 = Cocoa::MobiCocoaTest2._alloc._init
assert test2.is_a?(Cocoa::Object)
assert_equal 9, test2._ruby_method2(3).to_i

# call class method
assert_equal 27, Cocoa::MobiCocoaTest2._ruby_method3(3).to_i

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

@dynamic prop1;
@synthesize prop2, struct1;

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

@end