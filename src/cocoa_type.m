//
//  cocoa_types.m
//  MobiRuby
//
//  Created by Yuichiro MASUI on 4/16/12.
//  Copyright (c) 2012 Yuichiro MASUI. All rights reserved.
//

#import "cocoa_type.h"

#include "cfunc_type.h"

#include "mruby/string.h"
#include "mruby/class.h"
#include "mruby/proc.h"
#include "mruby/variable.h"

#include "ffi.h"

#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <string.h>


/* 
    Convert Objective-C type encodings to ffi_type
    See: http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
*/

#define case_type(encode, tclass) \
        case encode: \
            return cfunc_type_with_pointer(mrb, cfunc_state(mrb)->tclass, pointer_count);


static mrb_value
cfunc_type_with_pointer(mrb_state *mrb, struct RClass *type_rclass, int pointer_count)
{
    mrb_value type_class = mrb_obj_value(type_rclass);

    if(pointer_count > 0) {
        mrb_value cfunc_module = mrb_obj_value(cfunc_state(mrb)->namespace);
        for(int i = 0; i < pointer_count; ++i) {
            type_class = mrb_funcall(mrb, cfunc_module, "Pointer", 1, type_class);
        }
    }

    return type_class;
}


mrb_value
objc_type_to_cfunc_type(mrb_state *mrb, const char* objc_type)
{
    int pointer_count = 0;
    const char *encode = objc_type;
    
    while(*encode) {
        switch(*encode) {
        case_type('c', sint8_class);
        case_type('i', sint32_class);
        case_type('s', sint16_class);
        case_type('l', sint64_class);
        case_type('q', sint64_class); // todo:dosen't support long long
        case_type('C', uint8_class);
        case_type('I', uint32_class);
        case_type('S', uint16_class);
        case_type('L', uint64_class);
        case_type('Q', uint64_class); // todo:dosen't support unsigned long long
        case_type('f', float_class);
        case_type('d', double_class);
        case_type('B', uint8_class); // TODO: bit field
        case_type('v', void_class);
        case_type('?', pointer_class); // unknown and Blocks (@?)

        case '^':
            ++pointer_count;
            break;

        case '*': // CString
            return cfunc_type_with_pointer(mrb, cfunc_state(mrb)->pointer_class, pointer_count);

        case '@': // id(Object)
            if(*(encode+1) == '?') { // block
                return cfunc_type_with_pointer(mrb, cocoa_state(mrb)->block_class, pointer_count);
            }
            if(*(encode+1) == '"') {
                encode += 2;
                for(; *encode != '"'; ++encode) { /* no op */ }
            }
            return cfunc_type_with_pointer(mrb, cocoa_state(mrb)->object_class, pointer_count);

        case '#': // Class (class)
            return cfunc_type_with_pointer(mrb, cfunc_state(mrb)->pointer_class, pointer_count);

        case ':': // SEL (selector)
            return cfunc_type_with_pointer(mrb, cfunc_state(mrb)->pointer_class, pointer_count);

        case '[': // array [size type]
            {
                int array_size = 0;
                while(*encode >= '0' && *encode <= '9') {
                    array_size = (array_size * 10) + (*encode - '0');
                    ++encode;
                }
            }

            break;

        case '{': // struct {name=...}
            {
                ++encode;
                const char *name1 = encode;
                int size = 0;
                while(*encode != '=') {
                    ++encode;
                    ++size;
                }
                char *name = malloc(size + 1);
                memcpy(name, name1, size);
                name[size] = '\0';
                if (mrb_const_defined(mrb, mrb_obj_value(cocoa_state(mrb)->namespace), mrb_intern(mrb, name))) {
                    mrb_value klass = mrb_const_get(mrb, mrb_obj_value(cocoa_state(mrb)->namespace), mrb_intern(mrb, name));
                    free(name);
                    return cfunc_type_with_pointer(mrb, mrb_class_ptr(klass), pointer_count);
                }
                else {
                    // TODO: should support anonymous struct
                    free(name);
                    return cfunc_type_with_pointer(mrb, cfunc_state(mrb)->struct_class, pointer_count);
                }

            }
            break;

        case '(': // union (name=...)
            // should support (but libffi doesn't support union yet)
            break;

        case 'r': case 'n': case 'N':
        case 'o': case 'O': case 'R': case 'V':
            // skip
            break;        

        default:
            fprintf(stderr, "unknown cocoa argument encoding: %c in %s\n", *encode, objc_type);
            break;
        }

        ++encode;
    }
    
    // Unknow type encoding
    return mrb_nil_value();
}

