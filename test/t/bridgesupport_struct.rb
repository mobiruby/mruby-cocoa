assert_equal 8, ::Cocoa::Struct::MobiCocoaStruct2.size


############
# BEGIN C

struct BridgeSupportStructTable struct_table[] = {
    {.name = "MobiCocoaStruct2", .definition = "i1:i:i2:i"},
    {.name = NULL, .definition = NULL}
};

struct BridgeSupportConstTable const_table[] = {
    {.name = NULL, .type=NULL, .value = NULL}
};

struct BridgeSupportEnumTable enum_table[] = {
    {.name = NULL}
};

void
load_rubyvm(mrb_state *mrb) {
    load_cocoa_bridgesupport(mrb, struct_table, const_table, enum_table);  
}
