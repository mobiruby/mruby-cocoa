GEM := mruby-cocoa

-include $(MAKEFILE_4_GEM)

MRUBY_CFLAGS =
MRUBY_LDFLAGS =
MRUBY_LIBS = -framework Foundation

GEM_C_FILES := $(wildcard $(SRC_DIR)/*.c)
GEM_M_FILES := $(wildcard $(SRC_DIR)/*.m)
GEM_OBJECTS := $(patsubst %.c, %.o, $(GEM_C_FILES)) $(patsubst %.m, %.o, $(GEM_M_FILES))

GEM_RB_FILES := $(wildcard $(MRB_DIR)/*.rb)

GEM_TEST_C_FILES := $(wildcard $(TEST_DIR)/*.c)
GEM_TEST_M_FILES := $(wildcard $(TEST_DIR)/*.m)
GEM_TEST_OBJECTS := $(patsubst %.c, %.o, $(GEM_TEST_C_FILES)) $(patsubst %.m, %.o, $(GEM_TEST_M_FILES)) gem_test.o

gem-all : $(GEM_OBJECTS) gem-c-and-rb-files

gem-clean : gem-clean-c-and-rb-files

gem-test : $(GEM_TEST_OBJECTS) gem_test.o
	$(AR) rs gem_test.a $^


.PHONY : test
test: tmp/mruby tmp/mruby-cfunc
	rm -Rf `pwd`/tmp/mruby-cfunc
	ln -s `pwd` `pwd`/tmp/mruby-cfunc
	echo `pwd`/tmp/mruby-cfunc > tmp/mruby/mrbgems/GEMS.active
	cd tmp/mruby; ENABLE_GEMS=true ./minirake clean
	cd tmp/mruby; ENABLE_GEMS=true ./minirake test

tmp/mruby:
	mkdir -p tmp/mruby
	cd tmp; git clone https://github.com/mruby/mruby.git
	sed -i -e 's/\/\/\#define MRB_INT64/\#define MRB_INT64/' tmp/mruby/include/mrbconf.h

tmp/mruby-cfunc:
	cd tmp && git clone https://github.com/mobiruby/mruby-cfunc.git

tmp/libffi:
	mkdir -p tmp/
	cd tmp && git clone https://github.com/atgreen/libffi.git

lib/libffi.a: tmp/libffi
	mkdir -p vendors
	cd tmp/libffi && ./configure --prefix=`pwd`/../../vendors && make clean install CFLAGS="$(CFLAGS)"
	cp -r vendors/lib/libffi-3.0.11/include/* include/
	cp  vendors/lib/libffi.a lib/


%.o : %.m
	$(CC) -c $(CFLAGS) -std=c99 $(CPPFLAGS) $(GEM_INCLUDE_LIST) $< -o $@
