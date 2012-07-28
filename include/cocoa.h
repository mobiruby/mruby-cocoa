/*
** cfunc-mruby - Interface to C functions on mruby
**
** Copyright (c) MobiRuby developers 2012-
**
** Permission is hereby granted, free of charge, to any person obtaining
** a copy of this software and associated documentation files (the
** "Software"), to deal in the Software without restriction, including
** without limitation the rights to use, copy, modify, merge, publish,
** distribute, sublicense, and/or sell copies of the Software, and to
** permit persons to whom the Software is furnished to do so, subject to
** the following conditions:
**
** The above copyright notice and this permission notice shall be
** included in all copies or substantial portions of the Software.
**
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
** EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
** MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
** IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
** CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
** TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
** SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
**
** [ MIT license: http://www.opensource.org/licenses/mit-license.php ]
*/

#ifndef mruby_cocoa_h
#define mruby_cocoa_h

#include "mruby.h"

struct cocoa_state {
    struct RClass *namespace;
};

void init_cocoa_module(mrb_state *mrb);

/* offset of cocoa_state in mrb->ud */
extern size_t cocoa_state_offset;

/* service function for setting cocoa_state_offset */
#define cocoa_offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)

/*
example:

struct mrb_state_ud {
    struct cocoa_state cocoa_state;
};

cocoa_state_offset = cfunc_offsetof(struct mrb_state_ud, cocoa_state);

mrb_state *mrb = mrb_open();
mrb->ud = malloc(sizeof(struct mrb_state_ud));

init_cocoa_module(mrb);
*/


static inline struct cocoa_state *
cocoa_state(mrb_state* mrb)
{
  return (struct cocoa_state *)(mrb->ud + cocoa_state_offset);
}

#endif
