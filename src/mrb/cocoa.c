#include "mruby.h"
#include "mruby/irep.h"
#include "mruby/string.h"
#include "mruby/proc.h"

static mrb_code iseq_0[] = {
  0x01008037,
  0x0100000a,
  0x01008037,
  0x0100008a,
  0x01000111,
  0x01800005,
  0x0100c043,
  0x010000c5,
  0x01000005,
  0x01008044,
  0x010006c5,
  0x01000111,
  0x01800005,
  0x01010043,
  0x010007c5,
  0x01000291,
  0x01800005,
  0x01018043,
  0x01000945,
  0x01000291,
  0x01800005,
  0x0101c043,
  0x01000a45,
  0x01000291,
  0x01800005,
  0x01020043,
  0x01000b45,
  0x01000291,
  0x01800005,
  0x01024043,
  0x01000c45,
  0x01000291,
  0x01800005,
  0x01028043,
  0x01000d45,
  0x01000291,
  0x01800005,
  0x0102c043,
  0x01000e45,
  0x01000291,
  0x01800005,
  0x01030043,
  0x01000f45,
  0x01000291,
  0x01800005,
  0x01034043,
  0x01001045,
  0x01000291,
  0x01800005,
  0x01038043,
  0x01001145,
  0x01000291,
  0x01800005,
  0x0103c043,
  0x01001245,
  0x01000291,
  0x01800005,
  0x01040043,
  0x01001345,
  0x01000291,
  0x01800005,
  0x01044043,
  0x01001445,
  0x01000042,
  0x01800005,
  0x01048043,
  0x01001545,
  0x01000111,
  0x01800005,
  0x0100c043,
  0x01001645,
  0x0000004a,
};

static mrb_code iseq_1[] = {
  0x01000048,
  0x018002c0,
  0x01000046,
  0x01000048,
  0x018006c0,
  0x01004046,
  0x01000048,
  0x018008c0,
  0x01008046,
  0x01000006,
  0x01008047,
  0x01800ac0,
  0x0100c046,
  0x01000006,
  0x01008047,
  0x018012c0,
  0x01010046,
  0x01000006,
  0x01008047,
  0x018014c0,
  0x01014046,
  0x01000048,
  0x018016c0,
  0x01014046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_2[] = {
  0x02000026,
  0x03804001,
  0x04000005,
  0x03800020,
  0x0081c001,
  0x03800006,
  0x04004001,
  0x04800005,
  0x038040a0,
  0x0181c001,
  0x03804001,
  0x0400003d,
  0x04804001,
  0x053fff83,
  0x05c00003,
  0x06000005,
  0x0480c120,
  0x05000005,
  0x04810020,
  0x05000005,
  0x040080ac,
  0x04804001,
  0x05400003,
  0x05bfff03,
  0x05028041,
  0x05800005,
  0x0480c0a0,
  0x05000005,
  0x040080ac,
  0x048000bd,
  0x05000005,
  0x040080ac,
  0x0201c001,
  0x02820001,
  0x0380c001,
  0x0400013d,
  0x04800005,
  0x038140a0,
  0x04000340,
  0x03818020,
  0x03800384,
  0x04014001,
  0x04800404,
  0x05010001,
  0x0381c13f,
  0x03800029,
};

static mrb_code iseq_3[] = {
  0x02000026,
  0x02004001,
  0x02bfff83,
  0x03400003,
  0x03800005,
  0x02000120,
  0x0280003d,
  0x03010001,
  0x03800005,
  0x028040a0,
  0x02c00098,
  0x00400417,
  0x02004001,
  0x02c00003,
  0x033fff03,
  0x02814041,
  0x03000005,
  0x020000a0,
  0x02010016,
  0x00400797,
  0x028000bd,
  0x03010001,
  0x03800005,
  0x028040a0,
  0x02c00098,
  0x00400417,
  0x02004001,
  0x02c00003,
  0x033fff03,
  0x02814041,
  0x03000005,
  0x020000a0,
  0x02014016,
  0x00400097,
  0x02000005,
  0x02000029,
};

static mrb_code iseq_4[] = {
  0x02000026,
  0x02000006,
  0x02800006,
  0x03004001,
  0x03800005,
  0x028040a0,
  0x03000184,
  0x03800005,
  0x028080a0,
  0x03000005,
  0x020000a0,
  0x02000029,
};

static mrb_code iseq_5[] = {
  0x04000026,
  0x02800006,
  0x03000006,
  0x03804001,
  0x04000005,
  0x030040a0,
  0x03800184,
  0x04000005,
  0x030080a0,
  0x03808001,
  0x04000005,
  0x02800120,
  0x02808001,
  0x02800029,
};

static mrb_code iseq_6[] = {
  0x020800a6,
  0x05804001,
  0x06000005,
  0x05800020,
  0x0202c001,
  0x0582c037,
  0x06030037,
  0x0282c001,
  0x03030001,
  0x05808001,
  0x06000005,
  0x05804020,
  0x06400003,
  0x06800005,
  0x058080b2,
  0x05c00119,
  0x02808001,
  0x00400517,
  0x05808001,
  0x06000005,
  0x05804020,
  0x06400083,
  0x06800005,
  0x0580c0b1,
  0x06000005,
  0x05810020,
  0x06000340,
  0x05814020,
  0x0580003d,
  0x06014001,
  0x068000bd,
  0x07000005,
  0x0601c0a0,
  0x06800005,
  0x058180ac,
  0x0382c001,
  0x05800006,
  0x0601c001,
  0x0680c001,
  0x058200a0,
  0x05800511,
  0x05800493,
  0x06004001,
  0x06800511,
  0x06800613,
  0x07000511,
  0x07000613,
  0x06834137,
  0x07018001,
  0x07800005,
  0x068180ac,
  0x07000540,
  0x0582c120,
  0x0402c001,
  0x05800689,
  0x06020001,
  0x06800005,
  0x058380a0,
  0x05818001,
  0x06000005,
  0x05804020,
  0x063fff83,
  0x06800005,
  0x058080b2,
  0x05c00219,
  0x05814001,
  0x06000005,
  0x0583c020,
  0x00400397,
  0x05814001,
  0x0600013d,
  0x06800005,
  0x0581c0a0,
  0x060001bd,
  0x06800005,
  0x058180ac,
  0x0482c001,
  0x05800006,
  0x06024001,
  0x06820001,
  0x0700023d,
  0x07810001,
  0x0703c03e,
  0x078002bd,
  0x0703c03e,
  0x07818001,
  0x08000740,
  0x07844020,
  0x08000005,
  0x0781c020,
  0x0703c03e,
  0x0780033d,
  0x0703c03e,
  0x07800005,
  0x058401a0,
  0x05800029,
};

static mrb_code iseq_7[] = {
  0x02000026,
  0x02014015,
  0x02808015,
  0x03004001,
  0x03c00083,
  0x04000005,
  0x030080b0,
  0x03bfff83,
  0x04000005,
  0x0300c0ac,
  0x03800005,
  0x028040a0,
  0x03000005,
  0x020000a0,
  0x02018015,
  0x02808015,
  0x03004001,
  0x03c00083,
  0x04000005,
  0x030080b0,
  0x03c00003,
  0x04000005,
  0x0300c0ac,
  0x03800005,
  0x028040a0,
  0x03000005,
  0x020000a0,
  0x02000029,
};

static mrb_code iseq_8[] = {
  0x00080026,
  0x02800006,
  0x0300003d,
  0x03800005,
  0x028000a0,
  0x02800006,
  0x03004001,
  0x03bfff83,
  0x04000005,
  0x030080a0,
  0x03800005,
  0x028040a0,
  0x01814001,
  0x02800006,
  0x0300c001,
  0x03800005,
  0x028000a0,
  0x02800006,
  0x0300c001,
  0x03800005,
  0x0300c020,
  0x03800005,
  0x028000a0,
  0x0280c001,
  0x0301c015,
  0x030180b7,
  0x03804001,
  0x04400083,
  0x04804001,
  0x05000005,
  0x04814020,
  0x05400083,
  0x05800005,
  0x048180ae,
  0x05000005,
  0x03808120,
  0x0301c038,
  0x03800005,
  0x02813fa0,
  0x02800006,
  0x030000bd,
  0x03800005,
  0x028000a0,
  0x02800029,
};

static mrb_code iseq_9[] = {
  0x02000026,
  0x02004001,
  0x02800005,
  0x02000020,
  0x02000029,
};

static mrb_code iseq_10[] = {
  0x040800a6,
  0x04808001,
  0x05000005,
  0x04800020,
  0x02824001,
  0x0480c001,
  0x05000005,
  0x04804020,
  0x053fff83,
  0x05800005,
  0x048080b2,
  0x04c00319,
  0x04804001,
  0x05014001,
  0x05800005,
  0x0480c0a0,
  0x04800029,
  0x00402b17,
  0x04014001,
  0x0480003d,
  0x05000005,
  0x040100ac,
  0x02820001,
  0x0400c001,
  0x04bfff83,
  0x05000005,
  0x040140a0,
  0x040200b7,
  0x03020001,
  0x04400003,
  0x03820001,
  0x0401c001,
  0x0480c001,
  0x05000005,
  0x04804020,
  0x05000005,
  0x040180b3,
  0x04401619,
  0x0400c001,
  0x0481c001,
  0x053fff83,
  0x05800005,
  0x048100ac,
  0x05000005,
  0x040140a0,
  0x04800411,
  0x05000005,
  0x0401c0a0,
  0x04400099,
  0x00400097,
  0x00400f97,
  0x04014001,
  0x048000bd,
  0x0500c001,
  0x0581c001,
  0x063fff83,
  0x06800005,
  0x058100ac,
  0x06000005,
  0x050140a0,
  0x0482803e,
  0x0500013d,
  0x0482803e,
  0x05000005,
  0x040100ac,
  0x02820001,
  0x04018001,
  0x0480c001,
  0x0501c001,
  0x05c00003,
  0x06000005,
  0x050100ac,
  0x05800005,
  0x048140a0,
  0x05000005,
  0x040240a0,
  0x0401c001,
  0x04c00083,
  0x05000005,
  0x040100ac,
  0x03820001,
  0x003fe697,
  0x04018001,
  0x0480c001,
  0x0501c001,
  0x0580c001,
  0x06000005,
  0x05804020,
  0x0601c001,
  0x06800005,
  0x058280ae,
  0x06000005,
  0x04814120,
  0x05000005,
  0x040100ac,
  0x03020001,
  0x04004001,
  0x04814001,
  0x048240b7,
  0x05018001,
  0x04828038,
  0x05000005,
  0x0400ffa0,
  0x04000029,
  0x03800029,
};

static mrb_code iseq_11[] = {
  0x020800a6,
  0x0280003d,
  0x03004001,
  0x03800005,
  0x03004020,
  0x03bfff83,
  0x04400003,
  0x04800005,
  0x03008120,
  0x03800005,
  0x028000b2,
  0x02c00899,
  0x02800006,
  0x03000006,
  0x03804001,
  0x04000005,
  0x03804020,
  0x04400003,
  0x04bfff03,
  0x04020041,
  0x04800005,
  0x038080a0,
  0x03018137,
  0x03808001,
  0x0301c038,
  0x0380c001,
  0x0280ffa0,
  0x02800029,
  0x00400617,
  0x02000006,
  0x02800006,
  0x03000005,
  0x020100a0,
  0x02000006,
  0x028000bd,
  0x03004001,
  0x0281803e,
  0x0300013d,
  0x0281803e,
  0x03000005,
  0x020140a0,
  0x02000029,
};

static mrb_code iseq_12[] = {
  0x020800a6,
  0x0280003d,
  0x03004001,
  0x03800005,
  0x03004020,
  0x03bfff83,
  0x04400003,
  0x04800005,
  0x03008120,
  0x03800005,
  0x028000b2,
  0x02c00999,
  0x02800006,
  0x03000005,
  0x0280c020,
  0x03000006,
  0x03804001,
  0x04000005,
  0x03804020,
  0x04400003,
  0x04bfff03,
  0x04020041,
  0x04800005,
  0x038080a0,
  0x03018137,
  0x03808001,
  0x0301c038,
  0x0380c001,
  0x02813fa0,
  0x02800029,
  0x00400617,
  0x02000006,
  0x02800006,
  0x03000005,
  0x020140a0,
  0x02000006,
  0x028000bd,
  0x03004001,
  0x0281803e,
  0x0300013d,
  0x0281803e,
  0x03000005,
  0x020180a0,
  0x02000029,
};

static mrb_code iseq_13[] = {
  0x01000006,
  0x01008047,
  0x018002c0,
  0x01000046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_14[] = {
  0x02000026,
  0x02000006,
  0x02804001,
  0x03000005,
  0x020000a0,
  0x02400299,
  0x02000006,
  0x02804001,
  0x03000005,
  0x020040a0,
  0x02000029,
  0x02000006,
  0x0280003d,
  0x03004001,
  0x0281803e,
  0x030000bd,
  0x0281803e,
  0x03000005,
  0x020080a0,
  0x02000029,
};

static mrb_code iseq_15[] = {
  0x01000048,
  0x018002c0,
  0x01000046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_16[] = {
  0x040000a6,
  0x03004001,
  0x03800091,
  0x03800013,
  0x0381c0b7,
  0x04008001,
  0x04800005,
  0x038080ac,
  0x04000340,
  0x02800124,
  0x02800029,
};

static mrb_code iseq_17[] = {
  0x00080026,
  0x02004001,
  0x02800005,
  0x02000020,
  0x0200c015,
  0x02814037,
  0x03004001,
  0x02818038,
  0x03000005,
  0x02007fa0,
  0x02000029,
};

static mrb_code iseq_18[] = {
  0x01000006,
  0x01008047,
  0x018002c0,
  0x01000046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_19[] = {
  0x00000026,
  0x0180003d,
  0x01800029,
};

static mrb_code iseq_20[] = {
  0x01000006,
  0x01008047,
  0x018002c0,
  0x01000046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_21[] = {
  0x00000026,
  0x0180003d,
  0x01800029,
};

static mrb_code iseq_22[] = {
  0x01000006,
  0x01008047,
  0x018002c0,
  0x01000046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_23[] = {
  0x00000026,
  0x0180003d,
  0x01800029,
};

static mrb_code iseq_24[] = {
  0x01000006,
  0x01008047,
  0x018002c0,
  0x01000046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_25[] = {
  0x00000026,
  0x0180003d,
  0x01800029,
};

static mrb_code iseq_26[] = {
  0x01000006,
  0x01008047,
  0x018002c0,
  0x01000046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_27[] = {
  0x00000026,
  0x0180003d,
  0x01800029,
};

static mrb_code iseq_28[] = {
  0x01000006,
  0x01008047,
  0x018002c0,
  0x01000046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_29[] = {
  0x00000026,
  0x0180003d,
  0x01800029,
};

static mrb_code iseq_30[] = {
  0x01000006,
  0x01008047,
  0x018002c0,
  0x01000046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_31[] = {
  0x00000026,
  0x0180003d,
  0x01800029,
};

static mrb_code iseq_32[] = {
  0x01000006,
  0x01008047,
  0x018002c0,
  0x01000046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_33[] = {
  0x00000026,
  0x0180003d,
  0x01800029,
};

static mrb_code iseq_34[] = {
  0x01000006,
  0x01008047,
  0x018002c0,
  0x01000046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_35[] = {
  0x00000026,
  0x0180003d,
  0x01800029,
};

static mrb_code iseq_36[] = {
  0x01000006,
  0x01008047,
  0x018002c0,
  0x01000046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_37[] = {
  0x00000026,
  0x0180003d,
  0x01800029,
};

static mrb_code iseq_38[] = {
  0x01000006,
  0x01008047,
  0x018002c0,
  0x01000046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_39[] = {
  0x00000026,
  0x0180003d,
  0x01800029,
};

static mrb_code iseq_40[] = {
  0x01000006,
  0x01008047,
  0x018002c0,
  0x01000046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_41[] = {
  0x00000026,
  0x0180003d,
  0x01800029,
};

static mrb_code iseq_42[] = {
  0x01000006,
  0x01008047,
  0x018002c0,
  0x01000046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_43[] = {
  0x00000026,
  0x0180003d,
  0x01800029,
};

static mrb_code iseq_44[] = {
  0x01000006,
  0x01008047,
  0x018002c0,
  0x01000046,
  0x01000005,
  0x01000029,
};

static mrb_code iseq_45[] = {
  0x00000026,
  0x0180003d,
  0x01800029,
};

void
init_cocoa(mrb_state *mrb)
{
  int n = mrb->irep_len;
  int idx = n;
  int ai;
  mrb_irep *irep;

  mrb_add_irep(mrb, idx+46);

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 4;
  irep->ilen = 72;
  irep->iseq = iseq_0;
  irep->slen = 19;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*19);
  irep->syms[0] = mrb_intern(mrb, "$keeper");
  irep->syms[1] = mrb_intern(mrb, "$closure");
  irep->syms[2] = mrb_intern(mrb, "Cocoa");
  irep->syms[3] = mrb_intern(mrb, "Object");
  irep->syms[4] = mrb_intern(mrb, "Block");
  irep->syms[5] = mrb_intern(mrb, "CFunc");
  irep->syms[6] = mrb_intern(mrb, "Void");
  irep->syms[7] = mrb_intern(mrb, "Pointer");
  irep->syms[8] = mrb_intern(mrb, "SInt8");
  irep->syms[9] = mrb_intern(mrb, "UInt8");
  irep->syms[10] = mrb_intern(mrb, "SInt16");
  irep->syms[11] = mrb_intern(mrb, "UInt16");
  irep->syms[12] = mrb_intern(mrb, "SInt32");
  irep->syms[13] = mrb_intern(mrb, "UInt32");
  irep->syms[14] = mrb_intern(mrb, "SInt64");
  irep->syms[15] = mrb_intern(mrb, "UInt64");
  irep->syms[16] = mrb_intern(mrb, "Float");
  irep->syms[17] = mrb_intern(mrb, "Dobule");
  irep->syms[18] = mrb_intern(mrb, "String");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 26;
  irep->iseq = iseq_1;
  irep->slen = 6;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*6);
  irep->syms[0] = mrb_intern(mrb, "objc_property");
  irep->syms[1] = mrb_intern(mrb, "[]");
  irep->syms[2] = mrb_intern(mrb, "[]=");
  irep->syms[3] = mrb_intern(mrb, "define");
  irep->syms[4] = mrb_intern(mrb, "call_cocoa_method");
  irep->syms[5] = mrb_intern(mrb, "method_missing");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 7;
  irep->nregs = 12;
  irep->ilen = 46;
  irep->iseq = iseq_2;
  irep->slen = 9;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*9);
  irep->syms[0] = mrb_intern(mrb, "to_s");
  irep->syms[1] = mrb_intern(mrb, "objc_property_getAttributes");
  irep->syms[2] = mrb_intern(mrb, "+");
  irep->syms[3] = mrb_intern(mrb, "[]");
  irep->syms[4] = mrb_intern(mrb, "upcase");
  irep->syms[5] = mrb_intern(mrb, "split");
  irep->syms[6] = mrb_intern(mrb, "each");
  irep->syms[7] = mrb_intern(mrb, "setter");
  irep->syms[8] = mrb_intern(mrb, "getter");
  irep->plen = 3;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*3);
  irep->pool[0] = mrb_str_new(mrb, "set", 3);
  irep->pool[1] = mrb_str_new(mrb, ":", 1);
  irep->pool[2] = mrb_str_new(mrb, ",", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 4;
  irep->nregs = 7;
  irep->ilen = 36;
  irep->iseq = iseq_3;
  irep->slen = 2;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*2);
  irep->syms[0] = mrb_intern(mrb, "[]");
  irep->syms[1] = mrb_intern(mrb, "===");
  irep->plen = 2;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*2);
  irep->pool[0] = mrb_str_new(mrb, "G", 1);
  irep->pool[1] = mrb_str_new(mrb, "S", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 4;
  irep->nregs = 7;
  irep->ilen = 12;
  irep->iseq = iseq_4;
  irep->slen = 4;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*4);
  irep->syms[0] = mrb_intern(mrb, "objc_msgSend");
  irep->syms[1] = mrb_intern(mrb, "objc_property");
  irep->syms[2] = mrb_intern(mrb, "[]");
  irep->syms[3] = mrb_intern(mrb, "getter");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 5;
  irep->nregs = 8;
  irep->ilen = 14;
  irep->iseq = iseq_5;
  irep->slen = 4;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*4);
  irep->syms[0] = mrb_intern(mrb, "objc_msgSend");
  irep->syms[1] = mrb_intern(mrb, "objc_property");
  irep->syms[2] = mrb_intern(mrb, "[]");
  irep->syms[3] = mrb_intern(mrb, "setter");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 11;
  irep->nregs = 17;
  irep->ilen = 96;
  irep->iseq = iseq_6;
  irep->slen = 18;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*18);
  irep->syms[0] = mrb_intern(mrb, "objc_type_encode");
  irep->syms[1] = mrb_intern(mrb, "length");
  irep->syms[2] = mrb_intern(mrb, "==");
  irep->syms[3] = mrb_intern(mrb, "/");
  irep->syms[4] = mrb_intern(mrb, "to_i");
  irep->syms[5] = mrb_intern(mrb, "times");
  irep->syms[6] = mrb_intern(mrb, "+");
  irep->syms[7] = mrb_intern(mrb, "join");
  irep->syms[8] = mrb_intern(mrb, "define_method");
  irep->syms[9] = mrb_intern(mrb, "Closure");
  irep->syms[10] = mrb_intern(mrb, "CFunc");
  irep->syms[11] = mrb_intern(mrb, "new");
  irep->syms[12] = mrb_intern(mrb, "Pointer");
  irep->syms[13] = mrb_intern(mrb, "$closure");
  irep->syms[14] = mrb_intern(mrb, "<<");
  irep->syms[15] = mrb_intern(mrb, "first");
  irep->syms[16] = mrb_intern(mrb, "objc_addMethod");
  irep->syms[17] = mrb_intern(mrb, "map");
  irep->plen = 7;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*7);
  irep->pool[0] = mrb_str_new(mrb, "__", 2);
  irep->pool[1] = mrb_str_new(mrb, "_", 1);
  irep->pool[2] = mrb_str_new(mrb, ":", 1);
  irep->pool[3] = mrb_str_new(mrb, ":", 1);
  irep->pool[4] = mrb_str_new(mrb, "", 0);
  irep->pool[5] = mrb_str_new(mrb, ":@", 2);
  irep->pool[6] = mrb_str_new(mrb, "", 0);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 4;
  irep->nregs = 8;
  irep->ilen = 28;
  irep->iseq = iseq_7;
  irep->slen = 4;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*4);
  irep->syms[0] = mrb_intern(mrb, "<<");
  irep->syms[1] = mrb_intern(mrb, "[]");
  irep->syms[2] = mrb_intern(mrb, "*");
  irep->syms[3] = mrb_intern(mrb, "+");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 5;
  irep->nregs = 11;
  irep->ilen = 44;
  irep->iseq = iseq_8;
  irep->slen = 7;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*7);
  irep->syms[0] = mrb_intern(mrb, "p");
  irep->syms[1] = mrb_intern(mrb, "new");
  irep->syms[2] = mrb_intern(mrb, "[]");
  irep->syms[3] = mrb_intern(mrb, "class");
  irep->syms[4] = mrb_intern(mrb, "send");
  irep->syms[5] = mrb_intern(mrb, "length");
  irep->syms[6] = mrb_intern(mrb, "-");
  irep->plen = 2;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*2);
  irep->pool[0] = mrb_str_new(mrb, ">internal", 9);
  irep->pool[1] = mrb_str_new(mrb, "<internal", 9);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 4;
  irep->nregs = 5;
  irep->ilen = 5;
  irep->iseq = iseq_9;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "objc_type_encode");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 9;
  irep->nregs = 13;
  irep->ilen = 105;
  irep->iseq = iseq_10;
  irep->slen = 11;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*11);
  irep->syms[0] = mrb_intern(mrb, "to_s");
  irep->syms[1] = mrb_intern(mrb, "length");
  irep->syms[2] = mrb_intern(mrb, "==");
  irep->syms[3] = mrb_intern(mrb, "objc_msgSend");
  irep->syms[4] = mrb_intern(mrb, "+");
  irep->syms[5] = mrb_intern(mrb, "[]");
  irep->syms[6] = mrb_intern(mrb, "<");
  irep->syms[7] = mrb_intern(mrb, "is_a?");
  irep->syms[8] = mrb_intern(mrb, "Symbol");
  irep->syms[9] = mrb_intern(mrb, "<<");
  irep->syms[10] = mrb_intern(mrb, "-");
  irep->plen = 3;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*3);
  irep->pool[0] = mrb_str_new(mrb, ":", 1);
  irep->pool[1] = mrb_str_new(mrb, "", 0);
  irep->pool[2] = mrb_str_new(mrb, ":", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 5;
  irep->nregs = 10;
  irep->ilen = 42;
  irep->iseq = iseq_11;
  irep->slen = 6;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*6);
  irep->syms[0] = mrb_intern(mrb, "==");
  irep->syms[1] = mrb_intern(mrb, "to_s");
  irep->syms[2] = mrb_intern(mrb, "[]");
  irep->syms[3] = mrb_intern(mrb, "call_cocoa_method");
  irep->syms[4] = mrb_intern(mrb, "p");
  irep->syms[5] = mrb_intern(mrb, "raise");
  irep->plen = 3;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*3);
  irep->pool[0] = mrb_str_new(mrb, "_", 1);
  irep->pool[1] = mrb_str_new(mrb, "Unknow method ", 14);
  irep->pool[2] = mrb_str_new(mrb, "", 0);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 5;
  irep->nregs = 10;
  irep->ilen = 44;
  irep->iseq = iseq_12;
  irep->slen = 7;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*7);
  irep->syms[0] = mrb_intern(mrb, "==");
  irep->syms[1] = mrb_intern(mrb, "to_s");
  irep->syms[2] = mrb_intern(mrb, "[]");
  irep->syms[3] = mrb_intern(mrb, "class");
  irep->syms[4] = mrb_intern(mrb, "call_cocoa_method");
  irep->syms[5] = mrb_intern(mrb, "p");
  irep->syms[6] = mrb_intern(mrb, "raise");
  irep->plen = 3;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*3);
  irep->pool[0] = mrb_str_new(mrb, "_", 1);
  irep->pool[1] = mrb_str_new(mrb, "Unknow method ", 14);
  irep->pool[2] = mrb_str_new(mrb, "", 0);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 6;
  irep->iseq = iseq_13;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "const_missing");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 4;
  irep->nregs = 7;
  irep->ilen = 20;
  irep->iseq = iseq_14;
  irep->slen = 3;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*3);
  irep->syms[0] = mrb_intern(mrb, "exists_cocoa_class?");
  irep->syms[1] = mrb_intern(mrb, "load_cocoa_class");
  irep->syms[2] = mrb_intern(mrb, "raise");
  irep->plen = 2;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*2);
  irep->pool[0] = mrb_str_new(mrb, "uninitialized constant ", 23);
  irep->pool[1] = mrb_str_new(mrb, "", 0);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 5;
  irep->iseq = iseq_15;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "initialize");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 5;
  irep->nregs = 9;
  irep->ilen = 11;
  irep->iseq = iseq_16;
  irep->slen = 3;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*3);
  irep->syms[0] = mrb_intern(mrb, "Pointer");
  irep->syms[1] = mrb_intern(mrb, "CFunc");
  irep->syms[2] = mrb_intern(mrb, "+");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 4;
  irep->nregs = 7;
  irep->ilen = 11;
  irep->iseq = iseq_17;
  irep->slen = 2;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*2);
  irep->syms[0] = mrb_intern(mrb, "shift");
  irep->syms[1] = mrb_intern(mrb, "call");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 6;
  irep->iseq = iseq_18;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "objc_type_encode");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 3;
  irep->nregs = 4;
  irep->ilen = 3;
  irep->iseq = iseq_19;
  irep->slen = 0;
  irep->syms = NULL;
  irep->plen = 1;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*1);
  irep->pool[0] = mrb_str_new(mrb, "v", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 6;
  irep->iseq = iseq_20;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "objc_type_encode");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 3;
  irep->nregs = 4;
  irep->ilen = 3;
  irep->iseq = iseq_21;
  irep->slen = 0;
  irep->syms = NULL;
  irep->plen = 1;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*1);
  irep->pool[0] = mrb_str_new(mrb, "@", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 6;
  irep->iseq = iseq_22;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "objc_type_encode");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 3;
  irep->nregs = 4;
  irep->ilen = 3;
  irep->iseq = iseq_23;
  irep->slen = 0;
  irep->syms = NULL;
  irep->plen = 1;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*1);
  irep->pool[0] = mrb_str_new(mrb, "c", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 6;
  irep->iseq = iseq_24;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "objc_type_encode");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 3;
  irep->nregs = 4;
  irep->ilen = 3;
  irep->iseq = iseq_25;
  irep->slen = 0;
  irep->syms = NULL;
  irep->plen = 1;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*1);
  irep->pool[0] = mrb_str_new(mrb, "C", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 6;
  irep->iseq = iseq_26;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "objc_type_encode");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 3;
  irep->nregs = 4;
  irep->ilen = 3;
  irep->iseq = iseq_27;
  irep->slen = 0;
  irep->syms = NULL;
  irep->plen = 1;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*1);
  irep->pool[0] = mrb_str_new(mrb, "s", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 6;
  irep->iseq = iseq_28;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "objc_type_encode");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 3;
  irep->nregs = 4;
  irep->ilen = 3;
  irep->iseq = iseq_29;
  irep->slen = 0;
  irep->syms = NULL;
  irep->plen = 1;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*1);
  irep->pool[0] = mrb_str_new(mrb, "S", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 6;
  irep->iseq = iseq_30;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "objc_type_encode");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 3;
  irep->nregs = 4;
  irep->ilen = 3;
  irep->iseq = iseq_31;
  irep->slen = 0;
  irep->syms = NULL;
  irep->plen = 1;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*1);
  irep->pool[0] = mrb_str_new(mrb, "i", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 6;
  irep->iseq = iseq_32;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "objc_type_encode");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 3;
  irep->nregs = 4;
  irep->ilen = 3;
  irep->iseq = iseq_33;
  irep->slen = 0;
  irep->syms = NULL;
  irep->plen = 1;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*1);
  irep->pool[0] = mrb_str_new(mrb, "I", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 6;
  irep->iseq = iseq_34;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "objc_type_encode");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 3;
  irep->nregs = 4;
  irep->ilen = 3;
  irep->iseq = iseq_35;
  irep->slen = 0;
  irep->syms = NULL;
  irep->plen = 1;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*1);
  irep->pool[0] = mrb_str_new(mrb, "l", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 6;
  irep->iseq = iseq_36;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "objc_type_encode");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 3;
  irep->nregs = 4;
  irep->ilen = 3;
  irep->iseq = iseq_37;
  irep->slen = 0;
  irep->syms = NULL;
  irep->plen = 1;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*1);
  irep->pool[0] = mrb_str_new(mrb, "L", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 6;
  irep->iseq = iseq_38;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "objc_type_encode");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 3;
  irep->nregs = 4;
  irep->ilen = 3;
  irep->iseq = iseq_39;
  irep->slen = 0;
  irep->syms = NULL;
  irep->plen = 1;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*1);
  irep->pool[0] = mrb_str_new(mrb, "f", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 6;
  irep->iseq = iseq_40;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "objc_type_encode");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 3;
  irep->nregs = 4;
  irep->ilen = 3;
  irep->iseq = iseq_41;
  irep->slen = 0;
  irep->syms = NULL;
  irep->plen = 1;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*1);
  irep->pool[0] = mrb_str_new(mrb, "d", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 6;
  irep->iseq = iseq_42;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "objc_type_encode");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 3;
  irep->nregs = 4;
  irep->ilen = 3;
  irep->iseq = iseq_43;
  irep->slen = 0;
  irep->syms = NULL;
  irep->plen = 1;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*1);
  irep->pool[0] = mrb_str_new(mrb, "*", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 2;
  irep->nregs = 3;
  irep->ilen = 6;
  irep->iseq = iseq_44;
  irep->slen = 1;
  irep->syms = mrb_malloc(mrb, sizeof(mrb_sym)*1);
  irep->syms[0] = mrb_intern(mrb, "objc_type_encode");
  irep->plen = 0;
  irep->pool = NULL;
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  ai = mrb->arena_idx;
  irep = mrb->irep[idx] = mrb_malloc(mrb, sizeof(mrb_irep));
  irep->idx = idx++;
  irep->flags = 0 | MRB_ISEQ_NOFREE;
  irep->nlocals = 3;
  irep->nregs = 4;
  irep->ilen = 3;
  irep->iseq = iseq_45;
  irep->slen = 0;
  irep->syms = NULL;
  irep->plen = 1;
  irep->pool = mrb_malloc(mrb, sizeof(mrb_value)*1);
  irep->pool[0] = mrb_str_new(mrb, "@", 1);
  mrb->irep_len = idx;
  mrb->arena_idx = ai;

  mrb_run(mrb, mrb_proc_new(mrb, mrb->irep[n]), mrb_top_self(mrb));
}
