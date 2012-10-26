assert_equal 3061152000, Cocoa::Const::kCFAbsoluteTimeIntervalSince1904.to_i
assert_equal 1, Cocoa::Const::enum1


############
# BEGIN C

struct BridgeSupportStructTable struct_table[] = {
    {.name = NULL, .definition = NULL}
};

struct BridgeSupportConstTable const_table[] = {
    {.name = "kCFAbsoluteTimeIntervalSince1904", .type = "d", .value = &kCFAbsoluteTimeIntervalSince1904},
    {.name = "kCFNumberFormatterCurrencyCode", .type = "^{__CFString=}", .value = &kCFNumberFormatterCurrencyCode},
    {.name = "kCFTypeArrayCallBacks", .type = "{_CFArrayCallBacks=i^?^?^?^?}", .value = &kCFTypeArrayCallBacks},
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
