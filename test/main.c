#include "cocoa.h"
#include "cfunc.h"

#include "mruby.h"
#include "mruby/dump.h"
#include "mruby/proc.h"
#include "mruby/compile.h"

struct mrb_state_ud {
    struct cfunc_state cfunc_state;
    struct cocoa_state cocoa_state;
};


void
init_unittest(mrb_state *mrb);

void
init_cocoa_test(mrb_state *mrb);


int main(int argc, char *argv[])
{
    mrb_state *mrb = mrb_open();
    mrb->ud = malloc(sizeof(struct mrb_state_ud));

    cfunc_state_offset = cfunc_offsetof(struct mrb_state_ud, cfunc_state);
    init_cfunc_module(mrb);

    cocoa_state_offset = cocoa_offsetof(struct mrb_state_ud, cocoa_state);
    init_cocoa_module(mrb);

    init_unittest(mrb);
    if (mrb->exc) {
        mrb_p(mrb, mrb_obj_value(mrb->exc));
    }

    init_cocoa_test(mrb);
    if (mrb->exc) {
        mrb_p(mrb, mrb_obj_value(mrb->exc));
    }
}

