MRuby::Gem::Specification.new('mruby-cocoa') do |spec|
  spec.license = 'MIT'
  spec.authors = 'MobiRuby developers'

  build.cc = 'clang'
  spec.cflags = %w(-std=c99)
 
  # spec.mruby_cflags = ''
  # spec.mruby_ldflags = ''
  spec.mruby_libs = %w(-framework Foundation)
  # spec.mruby_includes = []
 
  # spec.rbfiles = Dir.glob("#{dir}/mrblib/*.rb")
  spec.objs << ["#{LIBFFI_DIR}/lib/libffi.a"]
  # spec.test_rbfiles = Dir.glob("#{dir}/test/*.rb")
  # spec.test_objs = Dir.glob("#{dir}/test/*.{c,cpp,m,asm,S}").map { |f| f.relative_path_from(dir).pathmap("#{build_dir}/%X.o") }
  # spec.test_preload = 'test/assert.rb'
end
