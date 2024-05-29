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

cmake -S "<source_dir>" -DCMAKE_INSTALL_PREFIX="..." `
	-DCMAKE_C_FLAGS="$ClFlags" `
	-DCMAKE_CXX_FLAGS="$ClFlags" `
	-DCMAKE_EXE_LINKER_FLAGS="$LinkFlags" `
	-DCMAKE_MODULE_LINKER_FLAGS="$LinkFlags" `
	-DCMAKE_SHARED_LINKER_FLAGS="$LinkFlags" `
	-DCMAKE_STATIC_LINKER_FLAGS="$LinkFlags" `
	-DBUILD_SHARED_LIBS=ON `
	-DBUILD_STATIC_LIBS=OFF `
	-DCURL_USE_SCHANNEL=ON `
	-DCURL_USE_OPENSSL=ON `
	-DCURL_USE_LIBPSL=ON `
	-DLIBPSL_INCLUDE_DIR="$InclDir" `
	-DLIBPSL_LIBRARY="$LibDir" `
	-DCURL_USE_LIBSSH2=ON `
	-DLIBSSH2_INCLUDE_DIR="$InclDir" `
	-DLIBSSH2_LIBRARY="$LibDir" `
	-DUSE_HTTPSRR=ON `
	-DUSE_WIN32_IDN=ON `
	-DUSE_WIN32_LDAP=ON `
	-DCURL_WINDOWS_SSPI=ON `
	-DENABLE_UNICODE=ON `
	-DUSE_NGHTTP2=ON `
	-DNGHTTP2_INCLUDE_DIR="$InclDir" `
	-DNGHTTP2_LIBRARY="$LibDir" `
	-DUSE_NGHTTP3=ON `
	-DENABLE_ARES=ON `
	-DCARES_INCLUDE_DIR="$InclDir" `
	-DCARES_LIBRARY="$LibDir" `
	-DCURL_ZSTD=ON `
	-DZstd_INCLUDE_DIR="$InclDir" `
	-DZstd_LIBRARY="$LibDir" `
	-DCURL_BROTLI=ON `
	-DBROTLI_INCLUDE_DIR="$InclDir" `
	-DBROTLIDEC_LIBRARY="$LibDir" `
	-DBROTLICOMMON_LIBRARY="$LibDir"

# Build and Install (Release or Debug)
cmake --build . --config Release --target INSTALL
# cmake --build . --config Debug --target INSTALL