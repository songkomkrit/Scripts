#!/bin/bash

GccFlags=" -O3 -pipe -lpthread -fstack-protector -fno-strict-aliasing"
GccFlags+=" -flto -fuse-linker-plugin"

export CC="<path_to_gcc>"
export CFLAGS=$GccFlags
export CXX="<path_to_g++>"
export CXXFLAGS=$GccFlags

<postgresql_source_dir>/configure --prefix="..." \
	--with-openssl \
	--with-llvm CLANG=/usr/bin/clang LLVM_CONFIG=/usr/bin/llvm-config \
	--with-perl PERL="<path_to_perl>" \
	--with-python PYTHON="<path_to_python3>" \
	--with-lz4 --with-zstd \
	--with-tcl --with-gssapi --with-ldap --with-pam \
	--with-libxml --with-libxslt
	
make -j8
make -j8 install
