#!/bin/bash

GccFlags=" -O3 -pipe -lpthread -fstack-protector -fno-strict-aliasing"
GccFlags+=" -fuse-linker-plugin"

export CC="<path_to_gcc>"
export CFLAGS=$GccFlags
export CXX="<path_to_g++>"
export CXXFLAGS=$GccFlags

<openssl_source_dir>/Configure \
	--prefix="..." \
	--openssldir=".../ssl" \
	enable-ec_nistp_64_gcc_128 \
	enable-egd enable-fips enable-tfo \
	threads enable-md2 enable-rc5 \
	enable-ktls \
	enable-acvp-tests \
	enable-crypto-mdebug enable-crypto-mdebug-backtrace \
	enable-trace enable-unstable-qlog \
	enable-brotli-dynamic zlib-dynamic enable-zstd-dynamic
	
make -j8
make -j8 install
