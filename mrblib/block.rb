class Cocoa::Block
  def initialize(result_type, arg_types, &block_)
    super(result_type, [CFunc::Pointer]+arg_types) do |*args|
      args.shift
      block_.call(*args)
    end
  end
end
