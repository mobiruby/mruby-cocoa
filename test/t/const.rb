assert_equal 12345, Cocoa::Const::test1.to_i
assert_equal 1, Cocoa::Const::enum1


############
# BEGIN C

struct BridgeSupportStructTable struct_table[] = {
    {.name = NULL, .definition = NULL}
};

const double test1 = 12345;

struct BridgeSupportConstTable const_table[] = {
    {.name = "test1", .type = "d", .value = &test1},
    {.name = NULL, .type=NULL, .value = NULL}
};

struct BridgeSupportEnumTable enum_table[] = {
    {.name="enum1"}, // 1
    {.name = NULL}
};

void
load_rubyvm(mrb_state *mrb) {
    enum_table[0].value = mrb_fixnum_value(1);
    load_cocoa_bridgesupport(mrb, struct_table, const_table, enum_table);  
}
