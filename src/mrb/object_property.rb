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
    self.objc_msgSend(:self, self.objc_property(prop_name)[:getter])
  end

  def []=(prop_name, value)
    self.objc_msgSend(:self, self.objc_property(prop_name)[:setter], value)
    value
  end
end
