#!/bin/bash

GccFlags=" -O3 -pipe -lpthread -fstack-protector -fno-strict-aliasing"
GccFlags+=" -flto -fuse-linker-plugin"

./Configure -des -Dprefix="..." \
	-Dcc="<path_to_gcc>" \
	-Doptimize="$GccFlags" \
	-Duseshrplib -Dusethreads \
	-Uuselargefiles -Duse64bitall -Dusemorebits \
	-Dusedevel -DEBUGGING=both

make -j8
make -j8 install

git clean -fdx
