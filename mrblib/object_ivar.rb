class Cocoa::Object
  def self.ivar(name, type)
    CFunc::call(CFunc::Int, "class_addIvar", self.addr, name.to_s, CFunc::Int(type.size), CFunc::Int(type.align), type.objc_type_encode)
  end

  class Ivar
    def initialize(instance)
      @instance = instance
    end

    def [](name)
      ptr = CFunc::Pointer.new
      ivar = CFunc::call(CFunc::Pointer, "object_getInstanceVariable", @instance, name.to_s, ptr.addr)
      encode = CFunc::call(CFunc::Pointer, "ivar_getTypeEncoding", ivar).to_s
      type = Cocoa::encode_to_type(encode)
      if type.ancestors.include?(CFunc::Pointer)
        type.new(ptr)
      else
        type.refer(ptr.addr)
      end
    end

    def []=(name, val_rb)
      ptr = CFunc::Pointer.new
      ivar = CFunc::call(CFunc::Pointer, "object_getInstanceVariable", @instance, name.to_s, ptr.addr)
      encode = CFunc::call(CFunc::Pointer, "ivar_getTypeEncoding", ivar).to_s
      type = Cocoa::encode_to_type(encode)
      if type.ancestors.include?(CFunc::Pointer)
        val = val_rb
      else
        val = type.refer(ptr.addr)
        val.value = val_rb
      end
      CFunc::call(CFunc::Pointer, "object_setInstanceVariable", @instance, name.to_s, val)
      val_rb
    end
  end
  
  def ivar
    @__ivar ||= Ivar.new(self)
    @__ivar
  end
end
