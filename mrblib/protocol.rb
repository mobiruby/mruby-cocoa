class Cocoa::Protocol
  class << self
    def block(*args, &block)
      proto = self.new(*args)
      proto.instance_eval(&block)
      proto.register
    end
  end

  def initialize(name, parents=[])
    @name = name
    @proto = CFunc::call(Cocoa::Object, "objc_allocateProtocol", name.to_s)

    parents.each do |proto_name|
      parent_proto = CFunc::call(Cocoa::Object, "objc_getProtocol", proto_name.to_s)
      CFunc::call(CFunc::Void, "protocol_addProtocol", @proto, parent_proto)
    end
    @isRequiredMethod = true
  end

  def optional
    @isRequiredMethod = false
  end

  def required
    @isRequiredMethod = true
  end

  def define(rettype, *args)
    objc_name, types = Cocoa::params_to_types(rettype, *args)
    CFunc::call(CFunc::Void, "protocol_addMethodDescription", @proto, Cocoa::selector(objc_name), types, @isRequiredMethod, true)
  end

  def define_class(rettype, *args)
    objc_name, types = Cocoa::params_to_types(rettype, *args)
    CFunc::call(CFunc::Void, "protocol_addMethodDescription", @proto, Cocoa::selector(objc_name), types, @isRequiredMethod, false)
  end

  def register
    CFunc::call(CFunc::Void, "objc_registerProtocol", @proto)
  end
end

def Cocoa::Protocol(*args, &block)
  Cocoa::Protocol.block(*args, &block)
end
