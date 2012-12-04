class Cocoa::Object
  class Ivar
    def initialize(instance)
      @instance = instance
    end

    def [](name)
      ptr = CFunc::Pointer.new
      ivar = CFunc::call(CFunc::Pointer, "object_getInstanceVariable", @instance, name.to_s, ptr.to_pointer)
      encode = CFunc::call(CFunc::Pointer, "ivar_getTypeEncoding", ivar).to_s
      type = Cocoa::encode_to_type(encode)
      if type.ancestors.include?(CFunc::Pointer)
        type.new(ptr)
      else
        type.refer(ptr.to_pointer)
      end
    end

    def []=(name, val_rb)
      ptr = CFunc::Pointer.new
      ivar = CFunc::call(CFunc::Pointer, "object_getInstanceVariable", @instance, name.to_s, ptr.to_pointer)
      encode = CFunc::call(CFunc::Pointer, "ivar_getTypeEncoding", ivar).to_s
      type = Cocoa::encode_to_type(encode)
      if type.ancestors.include?(CFunc::Pointer)
        val = val_rb
      else
        val = type.refer(ptr.to_pointer)
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