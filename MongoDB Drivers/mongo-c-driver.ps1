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

$InclDir = "..." # Include directory (built from sources or vcpkg)
$LibDir = "..." # Library directory (built from sources or vcpkg)

cmake -S "<mongo-c-driver_source>" -DCMAKE_INSTALL_PREFIX="..." `
	-DCMAKE_C_FLAGS="$ClFlags" `
	-DCMAKE_CXX_FLAGS="$ClFlags" `
	-DCMAKE_EXE_LINKER_FLAGS="$LinkFlags" `
	-DCMAKE_MODULE_LINKER_FLAGS="$LinkFlags" `
	-DCMAKE_SHARED_LINKER_FLAGS="$LinkFlags" `
	-DCMAKE_STATIC_LINKER_FLAGS="$LinkFlags" `
	-DCMAKE_PREFIX_PATH="<libmongocrypt_installation_dir>" `
	-DCMAKE_INCLUDE_PATH="$InclDir" `
	-DCMAKE_LIBRARY_PATH="$LibDir" `
	-DENABLE_SHARED=ON `
	-DENABLE_STATIC=OFF `
	-DTHREADS_PREFER_PTHREAD_FLAG=TRUE `
	-DENABLE_MONGOC=ON `
	-DUSE_SYSTEM_LIBBSON=OFF `
	-DMONGOC_ENABLE_STATIC_BUILD=OFF `
	-DENABLE_TESTS=OFF `
	-DENABLE_SSL=OPENSSL `
	-DENABLE_CRYPTO_SYSTEM_PROFILE=ON `
	-DENABLE_SASL=SSPI `
	-DENABLE_CLIENT_SIDE_ENCRYPTION=ON `
	-DENABLE_MAINTAINER_FLAGS=ON `
	-DENABLE_TRACING=ON `
	-DENABLE_COVERAGE=OFF `
	-DENABLE_DEBUG_ASSERTIONS=ON `
	-DENABLE_EXAMPLES=ON `
	-DENABLE_MAN_PAGES=ON `
	-DENABLE_HTML_DOCS=OFF `
	-DENABLE_UNINSTALL=ON `
	-DENABLE_SRV=ON `
	-DENABLE_SNAPPY=ON `
	-DENABLE_ZSTD=AUTO `
	-DENABLE_ZLIB=SYSTEM `
	-DZLIB_ROOT="..." `
	-DUSE_BUNDLED_UTF8PROC=ON `
	-DENABLE_MONGODB_AWS_AUTH=ON `
	-DENABLE_BUILD_DEPENDECIES=ON

# Build and Install (Release or Debug)
cmake --build . --config Release --target INSTALL
# cmake --build . --config Debug --target INSTALL