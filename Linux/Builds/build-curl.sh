#!/bin/bash

GccFlags=" -O3 -pipe -lpthread -fstack-protector -fno-strict-aliasing"
GccFlags+=" -flto -fuse-linker-plugin"
MyOpenssl="<OpenSSL_root_dir>"

cmake -S "<source_dir>" -DCMAKE_INSTALL_PREFIX="..." \
	-DCMAKE_C_COMPILER="<path_to_gcc>" \
	-DCMAKE_C_FLAGS="$GccFlags" \
	-DCMAKE_CXX_COMPILER="<path_to_g++>" \
	-DCMAKE_CXX_FLAGS="$GccFlags" \
	-DBUILD_SHARED_LIBS=ON \
	-DBUILD_STATIC_LIBS=OFF \
	-DOPENSSL_INCLUDE_DIR="$MyOpenssl/include/openssl" \
	-DOPENSSL_LIBRARIES="$MyOpenssl/lib64" \
	-DCURL_USE_SCHANNEL=OFF \
	-DCURL_USE_SECTRANSP=OFF \
	-DCURL_USE_OPENSSL=ON \
	-DCURL_USE_MBEDTLS=OFF \
	-DCURL_USE_BEARSSL=ON \
	-DCURL_USE_WOLFSSL=OFF \
	-DCURL_USE_GNUTLS=ON \
	-DCURL_USE_LIBPSL=ON \
	-DCURL_USE_LIBSSH2=ON \
	-DUSE_HTTPSRR=ON \
	-DENABLE_UNICODE=ON \
	-DUSE_NGHTTP2=ON \
	-DUSE_NGHTTP3=ON \
	-DENABLE_ARES=ON \
	-DCURL_ZLIB=ON \
	-DCURL_ZSTD=ON \
	-DCURL_BROTLI=ON 

make -j8
make -j8 install
