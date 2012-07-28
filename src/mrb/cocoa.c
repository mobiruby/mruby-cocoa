#include "mruby.h"
#include "mruby/irep.h"
#include "mruby/string.h"
#include "mruby/proc.h"

static mrb_code iseq_0[] = {
  0x0000004a,
};

void
init_cocoa(mrb_state *mrb)
{
  int n = mrb->irep_len;
  int idx = n;
  int ai;
  mrb_irep *irep;

  mrb_add_irep(mrb, idx+1);

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 0;
  irep->ilen = 1;
  irep->iseq = iseq_0;
  irep->slen = 0;
  irep->syms = NULL;
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  mrb_run(mrb, mrb_proc_new(mrb, mrb->irep[n]), mrb_top_self(mrb));
}
