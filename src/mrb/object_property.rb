class Cocoa::Object
  def objc_property(prop_name)
    prop_name = prop_name.to_s
    prop_attr_str = objc_property_getAttributes(prop_name)
    getter, setter = prop_name, "set#{prop_name.to_s.capitalize}:"
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
    self.objc_msgSend(:self, self.objc_property(prop_name)[:getter])
  end

  def []=(prop_name, value)
    self.objc_msgSend(:self, self.objc_property(prop_name)[:setter], value)
    value
  end

  # options: :copy, :readonly, :weak, :setter => xxx, :getter => xxx, :ivar => :xxx
  def self.property(name, type, *options_)
    options = {}
    options_.each do |opt|
      if opt.is_a?(Hash)
        opt.each do |k, v|
          options[k.to_sym] = v if v
        end
      else
        options[opt.to_sym] = true
      end
    end
    
    if options.has_key?(:getter)
      options[:getter] = options[:getter].to_s
    else
      options[:getter] = name.to_s
      # todo: define objc getter method
    end
    
    unless options.has_key?(:readonly)
      if options.has_key?(:setter)
        options[:setter] = options[:setter].to_s
      else
        options[:setter] = "set#{name.to_s.capitalize}:"
        # todo: define objc getter method
      end
    end

    # create property attributes
    # declare property
    nil
  end
end