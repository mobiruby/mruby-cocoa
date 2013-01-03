//
//  BridgeSupport loader
//
//  See Copyright Notice in cocoa.h
//

#ifndef MobiRubyDebug_cocoa_bridgesupport_h
#define MobiRubyDebug_cocoa_bridgesupport_h

#include "cocoa.h"

void
init_cocoa_bridge_support(mrb_state *mrb, struct RClass* module);

const char*
cocoa_bridgesupport_struct_lookup(mrb_state *mrb, const char *name);

#endif
