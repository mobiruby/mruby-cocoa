#include "cocoa.h"
#include "mruby.h"

struct BridgeSupportStructTable struct_table[];
struct BridgeSupportConstTable const_table[];
struct BridgeSupportEnumTable enum_table[];

void
mrb_mruby_cocoa_gem_test(mrb_state *mrb)
{
    enum_table[0].value = mrb_fixnum_value(1);
    load_cocoa_bridgesupport(mrb, struct_table, const_table, enum_table);  
}
