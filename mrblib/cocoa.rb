module Cocoa
  class <<self
  	def selector(name)
  	  CFunc::call(CFunc::Pointer, "sel_registerName", name.to_s)
  	end

  	def params_to_types(rettype_rb, *args)
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

      objc_name = types.length == 0 ? names.first : names.join(':')+':'
      
      [objc_name, "#{rettype}:@#{types.map{|t|t.objc_type_encode}.join}"]
    end
  end
end
