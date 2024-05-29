# Scripts

## Windows Utilities (Windows/Utilities)
* **Convert DOC/PPT to DOCX/PPTX to PDF:** ConvertToXPdf.ps1

## Parallel Mode
* ```git clone/pull -j<N> --recurse-submodules```
* ```msbuild <.sln_file> /m:<N> /p:Configuration=<Release/Debug> /p:Platform=x64 /p:SkipUWP=true```
* ```cmake --build . --config <Release/Debug> --target INSTALL --parallel <N>```
* ```make -j<N> [install]```
* ```mingw32-make -j<N> [install]```

## Useful Commands
* ```git reset --hard --recurse-submodules```
* ```git clean [--dry-run] -fdx```

## Builds on Windows (Windows/Builds)
* **Perl:** BuildPerl5.ps1
  - Wget binary can be downloaded from https://eternallybored.org/misc/wget
  - setx PERL_LWP_SSL_VERIFY_HOSTNAME -m 0
  - setx PERL_NET_HTTPS_SSL_SOCKET_CLASS -m Net::SSL
* **OpenSSL:** BuildOpenSSL.ps1
  - Perl and NASM (www.nasm.us) required
  - setx OPENSSL_CONF -m <path_to_openssl.cnf>
* **cURL:** BuildCurl.ps1
  - Here OpenSSL is used as an SSL backend in addition to the default Microsoft Schannel
* **Mosquitto MQTT:** BuildMosquitto.ps1
  - mosquitto.exe (broker) is in ```sbin``` directory
  - mosquitto_pub.exe (publisher) and mosquitto_sub.exe (subscriber) are in ```bin``` directory
  - OpenSSL is required when Mosquitto is built with SSL/TLS support (WITH_TLS = ON)
* **MongoDB C/C++ Drivers:** libmongocrypt.ps1 &rarr; mongo-c-driver.ps1 &rarr; mongo-cxx-driver.ps1
  - OpenSSL is required when MONGOCRYPT_CRYPTO = OpenSSL or ENABLE_SSL=OPENSSL is specified

## Builds on Linux
