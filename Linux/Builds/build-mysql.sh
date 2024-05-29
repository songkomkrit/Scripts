#!/bin/bash

Ver="8.4"
GccFlags=" -O3 -pipe -lpthread -fstack-protector -fno-strict-aliasing"
GccFlags+=" -flto -fuse-linker-plugin"

mkdir bld
cd bld

cmake .. \
	-DCMAKE_INSTALL_PREFIX="..." \
	-DMYSQL_DATADIR="..." \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_COMPILER="<path_to_gcc>" \
	-DCMAKE_C_FLAGS="$GccFlags" \
	-DCMAKE_CXX_COMPILER="<path_to_g++>" \
	-DCMAKE_CXX_FLAGS="$GccFlags" \
	-DWITH_LTO=ON \
	-DWITH_CURL="<curl_dir>" \
	-DWITH_SSL="<OpenSSL_root_dir>"
	
make -j8
make -j8 install
