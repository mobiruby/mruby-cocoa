class CreateInstanceTest1 < TestCase
  def test_10_nsstring
    @nsstr = Cocoa::NSString._stringWithUTF8String("string")
    a @nsstr.is_a?(Cocoa::Object)
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

  def test_10_const_f
    eq 3061152000, Cocoa::Const::kCFAbsoluteTimeIntervalSince1904.to_f
  end

end
ConstTest1.run
