$mobiruby_obj_holder = []

class Cocoa::Object
  class << self
    def type
      @type || CFunc::Void
    end

    def type=(type_)
      raise "Can't update" if CFunc::Pointer == self
      @type = type_
    end
  end

  def is_kind_of?(klass)
    if klass.is_a?(String) || klass.is_a?(Symbol)
      klass =  CFunc::call CFunc::Pointer, "NSClassFromString", Cocoa::NSString._stringWithUTF8String(klass.to_s)
    end

    self._isKindOfClass(klass).to_i != 0
  end

end

module Cocoa
  def self.const_missing(name)
    if ::Cocoa::Object.exists_cocoa_class?(name)
      return ::Cocoa::Object.load_cocoa_class(name)
    end
    raise "uninitialized constant #{name}" # ToDo: NameError
  end
end

class CFunc::Void
  def self.objc_type_encode; 'v'; end
end

class CFunc::Pointer
  def self.objc_type_encode; '@'; end
end

class CFunc::SInt8
  def self.objc_type_encode; 'c'; end
end

class CFunc::UInt8
  def self.objc_type_encode; 'C'; end
end

class CFunc::SInt16
  def self.objc_type_encode; 's'; end
end

class CFunc::UInt16
  def self.objc_type_encode; 'S'; end
end

class CFunc::SInt32
  def self.objc_type_encode; 'i'; end
end

class CFunc::UInt32
  def self.objc_type_encode; 'I'; end
end

class CFunc::SInt64
  def self.objc_type_encode; 'l'; end
end

class CFunc::UInt64
  def self.objc_type_encode; 'L'; end
end

class CFunc::SInt128
  def self.objc_type_encode; 'q'; end
end

class CFunc::UInt128
  def self.objc_type_encode; 'Q'; end
end

class CFunc::Float
  def self.objc_type_encode; 'f'; end
end

class CFunc::Double
  def self.objc_type_encode; 'd'; end
end

class String
  def self.objc_type_encode; '*'; end
  def to_ffi_value(ffi_type)
    if ffi_type == Cocoa::Object
      Cocoa::NSString._stringWithUTF8String(self).to_pointer
    else
      self.to_pointer
    end
  end
end

class Cocoa::Object
  def self.objc_type_encode;'@'; end
end
