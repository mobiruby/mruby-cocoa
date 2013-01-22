MRuby::Gem::Specification.new('mruby-cocoa') do |spec|
  spec.license = 'MIT'
  spec.authors = 'MobiRuby developers'

  [spec.cc, spec.cxx, spec.objc].each do |cc|
    cc.flags <<  %w(-std=c99)
  end

  spec.linker.flags << %w(-Wl,-allow_stack_execute -all_load)
  spec.linker.flags << %w(-framework Foundation)
  spec.test_preload = "#{dir}/test/mobitest.rb"
   
  # spec.rbfiles = Dir.glob("#{dir}/mrblib/*.rb")
  # spec.objs << ["#{LIBFFI_DIR}/lib/libffi.a"]
  # spec.test_rbfiles = Dir.glob("#{dir}/test/*.rb")
  # spec.test_objs = Dir.glob("#{dir}/test/*.{c,cpp,m,asm,S}").map { |f| f.relative_path_from(dir).pathmap("#{build_dir}/%X.o") }
  # spec.test_preload = 'test/assert.rb'
end
