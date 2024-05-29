#!/bin/bash

GccFlags=" -O3 -pipe -lpthread -fstack-protector -fno-strict-aliasing"
GccFlags+=" -flto -fuse-linker-plugin"

export CC="<path_to_gcc>"
export CFLAGS=$GccFlags
export CXX="<path_to_g++>"
export CXXFLAGS=$GccFlags

<python312_source_dir>/configure --prefix="..." \
	CC="<path_to_gcc>" \
	CFLAGS=$GccFlags \
	CXX="<path_to_g++>" \
	CFLAGS=$GccFlags \
	--enable-loadable-sqlite-extensions \
	--enable-optimizations --with-lto \
	--with-computed-gotos \
	--enable-profiling \
	--with-pydebug --with-trace-refs \
	--enable-shared \
	--with-system-expat \
	--with-openssl="<OpenSSL_root_dir>" \
	--with-openssl-rpath=auto
	
make -j8
make -j8 install
