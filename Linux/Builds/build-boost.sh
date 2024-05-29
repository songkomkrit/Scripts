#!/bin/bash

./b2 install -j8 \
	--prefix="<INSTALL_DIR>" \
	--build-dir="<BUILD_DIR>" \
	--user-config="config/user-config.jam" \
	address-model=64 variant=release \
	link=shared runtime-link=shared include=shared \
	threading=multi target-os=linux \
	--build-type=complete --layout=versioned --abbreviate-paths
