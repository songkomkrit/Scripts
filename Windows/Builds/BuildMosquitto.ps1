$Env:OPENSSL_ROOT_DIR = "..."

$InclDir = "..." # Include directory (built from sources or vcpkg)
$LibDir = "..." # Library directory (built from sources or vcpkg)

cmake -S "<source_dir>" -DCMAKE_INSTALL_PREFIX="..." `
	-DCJSON_INCLUDE_DIR="$InclDir" `
	-DCJSON_LIBRARY="$LibDir" `
	-DWITH_BUNDLED_DEPS=ON `
	-DWITH_TLS=ON `
	-DWITH_TLS_PSK=ON `
	-DWITH_EC=ON `
	-DWITH_UNIX_SOCKETS=OFF `
	-DWITH_SOCKS=ON `
	-DWITH_SRV=ON `
	-DWITH_THREADING=ON `
	-DWITH_CJSON=ON `
	-DWITH_CLIENTS=ON `
	-DWITH_BROKER=ON `
	-DWITH_APPS=ON `
	-DWITH_PLUGINS=ON `
	-DDOCUMENTATION=OFF

# Build and Install (Release or Debug)
cmake --build . --config Release --target INSTALL
# cmake --build . --config Debug --target INSTALL