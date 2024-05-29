#!/bin/bash

GccFlags=" -O3 -pipe -lpthread -fstack-protector -fno-strict-aliasing"
GccFlags+=" -flto -fuse-linker-plugin"

cmake -S "<source_dir>" -DCMAKE_INSTALL_PREFIX="..." \
	-DCMAKE_C_COMPILER="<path_to_gcc>" \
	-DCMAKE_C_FLAGS="$GccFlags" \
	-DCMAKE_CXX_COMPILER="<path_to_g++>" \
	-DCMAKE_CXX_FLAGS="$GccFlags" \
	-DOPENSSL_INCLUDE_DIR="<OpenSSL_root_dir>/include/openssl" \
	-DWITH_BUNDLED_DEPS=ON \
	-DWITH_DLT=OFF \
	-DWITH_TLS=ON \
	-DWITH_TLS_PSK=ON \
	-DWITH_EC=ON \
	-DWITH_UNIX_SOCKETS=ON \
	-DWITH_SOCKS=ON \
	-DWITH_SRV=ON \
	-DWITH_THREADING=ON \
	-DWITH_CJSON=ON \
	-DWITH_CLIENTS=ON \
	-DWITH_BROKER=ON \
	-DWITH_APPS=ON \
	-DWITH_PLUGINS=ON \
	-DDOCUMENTATION=OFF

make -j8
make -j8 install
