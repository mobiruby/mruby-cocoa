$mobiruby_obj_holder = []

$closure = []

class Cocoa::Object

    def objc_property(prop_name)
        prop_name = prop_name.to_s
        prop_attr_str = objc_property_getAttributes(prop_name)
        getter, setter = prop_name, 'set'+prop_name[0,1].upcase+prop_name[1..-1]+":"
        prop_attr_str.split(',').each do |a|
          case a[0,1]
          when 'G'
            getter = a[1..-1]

          when 'S'
            setter = a[1..-1]
          end
        end
        {:setter => setter, :getter => getter}
    end

    def [](prop_name)
        self.objc_msgSend(self.objc_property(prop_name)[:getter])
    end

    def []=(prop_name, value)
        self.objc_msgSend(self.objc_property(prop_name)[:setter], value)
        value
    end

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

    def self.call_cocoa_method(obj, name, *args, &block)
        method_name = name.to_s
        if args.length == 0
            return obj.objc_msgSend(method_name)
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

            return obj.objc_msgSend(method_name, *values)
        end
    end

    def self.method_missing(name, *args, &block)
        if '_' == name.to_s[0, 1]
            return call_cocoa_method(self, name.to_s[1..-1], *args, &block)
        else
            raise "Unknow method #{name}"
        end
    end

    def method_missing(name, *args, &block)
        if '_' == name.to_s[0, 1]
            return self.class.call_cocoa_method(self, name.to_s[1..-1], *args, &block)
        else
            raise "Unknow method #{name}"
        end
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


class Cocoa::Block
    def initialize(result_type, arg_types, &block_)
        super(result_type, [CFunc::Pointer]+arg_types) do |*args|
            args.shift
            block_.call(*args)
        end
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

class CFunc::Dobule
    def self.objc_type_encode; 'd'; end
end

class ::String
    def self.objc_type_encode; '*'; end
end

class Cocoa::Object
    def self.objc_type_encode;'@'; end
end
