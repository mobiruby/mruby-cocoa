
class TestCase
  attr_reader :errors

  def initialize
    @errors = []
    @current_test = nil
  end

  def assert_equal(exp, act, msg = nil)
    if exp == act
      print '.'
    else
      print '*'
      @errors << [@current_test, msg]
    end
  end

  def assert(test, msg = nil)
    if test
      print '.'
    else
      print '*'
      @errors << [@current_test, msg]
    end
  end

  def a(test)
    assert(test)
  end

  def eq(exp, act, msg = nil)
    assert_equal(exp, act, msg)
  end

  def run
    @errors = []
    puts self.class
    self.methods.select{|m| m.to_s[0, 5] == 'test_' }.sort.each do |m|
      @current_test = m
      begin
        print "  #{m}: "
        send(m)
        puts ''
      rescue => e
        puts 'E'
        @errors << [@current_test, e]
      end
      @current_test = nil
    end
    puts
    unless @errors.empty?
      @errors.each do |line|
        p line
      end
    end
  end

  def self.run
    self.new.run
  end
end


class CreateInstanceTest1 < TestCase
  def test_10_nsstring
    @nsstr = Cocoa::NSString._stringWithUTF8String("string")
    a @nsstr.is_a?(Cocoa::Object)
    a @nsstr.is_kind_of?("NSString")
    a @nsstr.is_kind_of?("NSObject")
    a !@nsstr.is_kind_of?("NSNumber")
    eq "<__NSCFConstantString", @nsstr.inspect[0,21]
    eq 6, @nsstr._length.value
  end
end
CreateInstanceTest1.run


class Cocoa::MobiCocoaTest2 < Cocoa::MobiCocoaTest1
  define CFunc::Int, :ruby_method1 do
    1
  end

  define CFunc::Int, :ruby_method2, CFunc::Int do |i|
    i.value ** 2
  end
end


class MobiCocoaTest1Test < TestCase
  def test_10_call_classmethod
    @result1 = Cocoa::MobiCocoaTest1._classMethod1
    a @result1.is_a?(Cocoa::Object)
    eq "classMethod1Test", @result1._UTF8String.to_s
  end

  def test_20_create_instance
    @test1 = Cocoa::MobiCocoaTest1._alloc._init
    a @test1.is_a?(Cocoa::Object)
  end

  def test_30_call_instance_method1
    result = @test1._intToString(CFunc::Int(10))
    eq "value=10", result._UTF8String.to_s
  end

  def test_40_call_instance_method2_with_mruby_value
    result = @test1._uint16ToString(CFunc::SInt8(-1))
    eq "value=255", result._UTF8String.to_s
  end

  def test_50_call_instance_method2_with_ruby_value
    result = @test1._uint16ToString(-1)
    eq "value=65535", result._UTF8String.to_s
  end

  def test_60_prop_get
    result = @test1[:prop1]
    eq "PROP1_", result._UTF8String.to_s
  end

  def test_70_prop_get
    val = Cocoa::NSString._stringWithUTF8String("PROP2")
    @test1[:prop2] = val
    result = @test1[:prop2]
    eq "PROP2", result._UTF8String.to_s

    @test1[:prop2] = Cocoa::NSString._stringWithUTF8String("PROP2_")
    result = @test1[:prop2]
    eq "PROP2_", result._UTF8String.to_s
  end

  def test_90_struct_get
    result = @test1[:struct1]
    eq 100, result[:i]
  end

end
MobiCocoaTest1Test.run

class MobiCocoaTest2Test < TestCase
  
  def test_10_call_rubymethod1
    test2 = Cocoa::MobiCocoaTest2._alloc._init
    a test2.is_a?(Cocoa::Object)
    eq 1, test2._ruby_method1.value
  end

  def _test_20_call_rubymethod2
    test2 = Cocoa::MobiCocoaTest2._alloc._init
    # todo:
  end

end
MobiCocoaTest2Test.run

class MobiCocoaStruct2Test < TestCase
  def test_10_load_bridgesupport
    eq 8, ::Cocoa::Struct::MobiCocoaStruct2.size
    eq 8, ::Cocoa::Struct::MobiCocoaStruct2.align
  end
end
MobiCocoaStruct2Test.run


class MobiBlocksTest1 < TestCase

  def test_10_call_with_block
    block = Cocoa::Block.new(CFunc::Int, [CFunc::Int]) { |i|
      i.value + 1
    }
    @test2 = Cocoa::MobiCocoaTest2._alloc._init
    result = @test2._testBlocks1 block
    eq 12, result.value
  end

  def test_20_call_with_block2
    block = Cocoa::Block.new(CFunc::Int, [CFunc::Int]) { |i|
      i.value + 1
    }
    @test2 = Cocoa::MobiCocoaTest2._alloc._init
    result = @test2._testBlocks2 block
    eq 12, result.value
  end

end
MobiBlocksTest1.run

class ConstTest1 < TestCase

  def test_10_const_i
    eq 3061152000, Cocoa::Const::kCFAbsoluteTimeIntervalSince1904.to_i
  end

  def test_20_enum1
    eq 1, Cocoa::Const::enum1
  end

end
ConstTest1.run

############
# BEGIN C


struct BridgeSupportStructTable struct_table[] = {
    {.name = "CGPoint", .definition = "x:f:y:f"},
    {.name = "CGSize", .definition = "width:f:height:f"},
    {.name = "CGRect", .definition = "origin:{CGPoint}:size:{CGSize}"},
    {.name = "MobiCocoaStruct1", .definition = "i:i:d:d:str:*:obj:@:iptr:^i"},
    {.name = "MobiCocoaStruct2", .definition = "i1:i:i2:i"},
    {.name = NULL, .definition = NULL}
};

struct BridgeSupportConstTable const_table[] = {
    {.name = "kCFAbsoluteTimeIntervalSince1904", .type = "d", .value = &kCFAbsoluteTimeIntervalSince1904},
    {.name = "kCFNumberFormatterCurrencyCode", .type = "^{__CFString=}", .value = &kCFNumberFormatterCurrencyCode},
    {.name = "kCFTypeArrayCallBacks", .type = "{_CFArrayCallBacks=i^?^?^?^?}", .value = &kCFTypeArrayCallBacks},
    {.name = NULL, .type=NULL, .value = NULL}
};

struct BridgeSupportEnumTable enum_table[] = {
    {.name="enum1"}, // 1
    {.name = NULL}
};

void
load_rubyvm(mrb_state *mrb) {
    enum_table[0].value = mrb_fixnum_value(1);
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
