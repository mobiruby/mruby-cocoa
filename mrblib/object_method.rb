$closure = []

class Cocoa::Object

  def self.define(rettype_rb, *args, &block)
    rettype = rettype_rb.objc_type_encode
    names, types = [], []
    if args.length == 1
      names = args
    else
      (args.length/2).to_i.times do |i|
        names << args[i*2+0]
        types << args[i*2+1]
      end
    end

    internal_method_name = "_mruby_cocoa_"+names.join('_')
    define_method(internal_method_name, &block)

    closure = CFunc::Closure.new(rettype_rb, [CFunc::Pointer, CFunc::Pointer] + types) do |*a|
      self.new(a[0]).send(internal_method_name, *a[2, a.length-2])
    end
    $closure << closure
    
    objc_name = types.length == 0 ? names.first : names.join(':')+':'
    objc_addMethod objc_name, closure, "#{rettype}:@#{types.map{|t|t.objc_type_encode}.join}"
  end

  def self.define_class(rettype_rb, *args, &block)
    rettype = rettype_rb.objc_type_encode
    names, types = [], []
    if args.length == 1
      names = args
    else
      (args.length/2).to_i.times do |i|
        names << args[i*2+0]
        types << args[i*2+1]
      end
    end

    internal_method_name = "_mruby_cocoa_class_"+names.join('_')
    define_method(internal_method_name, &block)

    closure = CFunc::Closure.new(rettype_rb, [CFunc::Pointer, CFunc::Pointer] + types) do |*a|
      self.new(a[0]).send(internal_method_name, *a[2, a.length-2])
    end
    $closure << closure
    
    objc_name = types.length == 0 ? names.first : names.join(':')+':'
    objc_addClassMethod objc_name, closure, "#{rettype}:@#{types.map{|t|t.objc_type_encode}.join}"
  end

  def self.call_cocoa_method(target, obj, name, *args, &block)
    method_name = name.to_s
    if args.length == 0
      return obj.objc_msgSend(target, method_name)
    else
      method_name += ':'
      values = [args[0]] 
      pos = 1
      while pos < args.length do
        break unless args[pos+0].is_a?(Symbol)
        method_name += "#{args[pos+0]}:"
        values << args[pos+1]
        pos += 2
      end
      values += args[pos, args.length - pos]

      return obj.objc_msgSend(target, method_name, *values)
    end
  end

  def self.method_missing(name, *args, &block)
    if '_' == name.to_s[0, 1]
      return call_cocoa_method(:self, self, name.to_s[1..-1], *args, &block)
    else
      raise "Unknown method #{name}"
    end
  end

  def method_missing(name, *args, &block)
    if '_' == name.to_s[0, 1]
      return self.class.call_cocoa_method(:self, self, name.to_s[1..-1], *args, &block)
    else
      raise "Unknown method #{name}"
    end
  end

  def self._super(name, *args, &block)
    if '_' == name.to_s[0, 1]
      return call_cocoa_method(:super, self, name.to_s[1..-1], *args, &block)
    else
      raise "Unknown method #{name}"
    end
  end

  def _super(name, *args, &block)
    if '_' == name.to_s[0, 1]
      return self.class.call_cocoa_method(:super, self, name.to_s[1..-1], *args, &block)
    else
      raise "Unknown method #{name}"
    end
  end
end
