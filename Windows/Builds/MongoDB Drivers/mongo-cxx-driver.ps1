$Env:OPENSSL_ROOT_DIR = "..."

# /favor:<blend|AMD64|INTEL64|ATOM>
$ClFlags = @"
	/favor:blend /O2 `
	/GR /guard:cf /guard:ehcont /GL /GA /GT `
	/EHsc /Qpar /Qspectre-load-cf /Qspectre-jmp
"@ -replace "`n",""
$LinkFlags = @"
	/LTCG `
	/OPT:REF /OPT:ICF
"@ -replace "`n",""

cmake -S "<mongo-cxx-driver_source>" -DCMAKE_INSTALL_PREFIX="..." `
	-DCMAKE_C_FLAGS="$ClFlags" `
	-DCMAKE_CXX_FLAGS="$ClFlags" `
	-DCMAKE_EXE_LINKER_FLAGS="$LinkFlags" `
	-DCMAKE_MODULE_LINKER_FLAGS="$LinkFlags" `
	-DCMAKE_SHARED_LINKER_FLAGS="$LinkFlags" `
	-DCMAKE_STATIC_LINKER_FLAGS="$LinkFlags" `
	-DCMAKE_PREFIX_PATH="<mongo-c-driver_installation_dir>" `
	-DBUILD_SHARED_LIBS=ON `
	-DTHREADS_PREFER_PTHREAD_FLAG=TRUE `
	-DBUILD_SHARED_AND_STATIC_LIBS=OFF `
	-DBUILD_SHARED_LIBS_WITH_STATIC_MONGOC=OFF `
	-DENABLE_BSONCXX_POLY_USE_IMPLS=ON `
	-DENABLE_ABI_TAG_IN_LIBRARY_FILENAMES=ON `
	-DENABLE_ABI_TAG_IN_PKGCONFIG_FILENAMES=ON `
	-DENABLE_UNINSTALL=ON `
	-DENABLE_CODE_COVERAGE=OFF `
	-DENABLE_TESTS=ON `
	-DENABLE_MACRO_GUARD_TESTS=ON

# Build and Install (Release or Debug)
cmake --build . --config Release --target INSTALL
# cmake --build . --config Debug --target INSTALL