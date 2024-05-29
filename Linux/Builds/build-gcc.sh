#!/bin/bash

<gcc_source_dir>/configure --prefix="..." \
	--enable-languages=all \
	--enable-lto \
	--enable-large-address-aware \
	--enable-threads \
	--enable-tls \
	--enable-shared \
	--enable-checking \
	--enable-stage1-checking \
	--enable-host-shared \
	--enable-host-pie \
	--enable-host-bind-now \
	--with-gnu-as \
	--enable-default-pie \
	--enable-default-ssp \
	--enable-nls \
	--enable-cet \
	--enable-fdpic \
	--enable-valgrind-annotations \
	--enable-decimal-float \
	--enable-s390-excess-float-precision
	
make -j8
make -j8 install
