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

cmake -S "<libmongocrypt_source>" -DCMAKE_INSTALL_PREFIX="..." `
	-DCMAKE_C_FLAGS="$ClFlags" `
	-DCMAKE_CXX_FLAGS="$ClFlags" `
	-DCMAKE_EXE_LINKER_FLAGS="$LinkFlags" `
	-DCMAKE_MODULE_LINKER_FLAGS="$LinkFlags" `
	-DCMAKE_SHARED_LINKER_FLAGS="$LinkFlags" `
	-DCMAKE_STATIC_LINKER_FLAGS="$LinkFlags" `
	-DENABLE_STATIC=OFF `
	-DENABLE_PIC=OFF `
	-DENABLE_WINDOWS_STATIC_RUNTIME=OFF `
	-DENABLE_BUILD_FOR_PPA=OFF `
	-DENABLE_ONLINE_TESTS=ON `
	-DENABLE_USE_RANGE_V2=ON `
	-DMONGOCRYPT_ENABLE_DECIMAL128=ON `
	-DUSE_SHARED_LIBBSON=ON `
	-DMONGOCRYPT_CRYPTO=OpenSSL `
	-DENABLE_TRACE=OFF `
	-DBUILD_TESTING=ON `
	-DENABLE_ZLIB=SYSTEM `
	-DZLIB_ROOT="..." `
	-DICU_ROOT="..."
	
# Build and Install (Release or Debug)
cmake --build . --config Release --target INSTALL
# cmake --build . --config Debug --target INSTALL