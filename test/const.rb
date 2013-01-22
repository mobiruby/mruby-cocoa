mobiruby_test "Cocoa::const" do
  assert_equal 12345, Cocoa::Const::test1.to_i
  assert_equal 1, Cocoa::Const::enum1
end