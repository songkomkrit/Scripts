# Scripts

## Windows Utilities (Windows/Utilities)
* **Convert DOC/PPT to DOCX/PPTX to PDF:** ConvertToXPdf.ps1
  - ```.\ConvertToXPdf.ps1 -Type <pdf:default/x> -Path <Directory> -Dry <$true:default/$false>```
  - To convert from DOC/PPT to DOCX/PPTX, run ```.\ConvertToXPdf.ps1 -Type x -Path <Directory> -Dry $false```
  - To convert from DOCX/PPTX to PDF, run ```.\ConvertToXPdf.ps1 -Path <Directory> -Dry $false```
    
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
  - To upgrade all installed modules, run ```cpan -u```
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
  - OpenSSL is required when MONGOCRYPT_CRYPTO = OpenSSL or ENABLE_SSL = OPENSSL is specified

## Builds on Linux (Linux/Builds)
* **Add environment variables (if necessary) to ```.bashrc```**
  - ```export PATH="${INSTALL_DIR}/bin:$PATH"```
  - ```export LD_LIBRARY_PATH="${LIBRARY_DIR}/${LD_LIBRARY_PATH}"```
  - ```export LDFLAGS="$LDFLAGS -L${LIBRARY_DIR} -Wl,-rpath,${LIBRARY_DIR}"```
  - In the case of building with address sanitizer (ASAN), thought not recommended for production use, please add ```export LD_PRELOAD=$(gcc -print-file-name=libasan.so)```
* **GCC:** build-gcc.sh
  - GCC11 can be installed via the command ```sudo apt install build-essential```
  - GCC11 is used to build the latest GCC15 (Experimental)
* **Perl:** build-perl5.sh
* **OpenSSL:** build-openssl.sh
* **Python 3.12:** build-python312.sh
  - To suppress warnings, use ```export PYTHONWARNINGS="ignore::DeprecationWarning"```
* **cURL:** build-curl.sh
* **Mosquitto MQTT:** build-mosquitto.sh
* **MySQL:** build-mysql.sh
  - Create the configuration file ```my.cnf``` containing ```[mysqld]```, ```basedir```, ```lc_messages_dir```, ```datadir```, ```log_bin```, ```general_log=1```, ```general_log_file```, ```log_error```, ```slow_query_log=1``` and ```slow_query_log_file```
  - Initialization: ```mysqld --defaults-file=my.cnf --initialize```
  - Server
    * ```mysqld --defaults-file=my.cnf -u root --console```
    * ```mysqladmin -u root status/shutdown -p```
  - Client: ```mysql -u root -p```
* **PostgreSQL:** build-postgresql.sh
  - The configuration directory may include ```pg_hba.conf```, ```pg_ident.conf```, ```pg_service.conf``` and ```postgresql.conf```
    * In ```pg_hba.conf```, please comment at the very end every line begining with ```@remove-line-for-nolocal``` and type ```scram-sha-256``` as ```METHOD```
  - Initialization: ```initdb -d <data_dir> -U postgres -W -E UTF8 -A scram-sha-256```
    * To add users, follow these steps:
      - ```psql -d template1```
      - ```\l```
      - ```CREATE DATABASE "username" WITH OWNER "username" ENCODING 'UTF8';```
      - ```\q```
  - Server: ```pg_ctl -D <conf/data_dir> -U <username> start/stop/status```
  - Client: ```psql -U <username>```

## Homework Grading on Linux (Linux/Grading)
* **PostgreSQL Assignments (PostgreSQLHwk)** 
  - Use ```rclone copy``` to retreive submitted student files from SharePoint/OneDrive (download.sh) with the option ```--filter-from``` to filter the files based on the rule (filterfiles.txt)
  - The main file used for grading is grade-all.sh where the file grade-single.sh is called
    * Run ```chmod +x grade*``` to make grade-all.sh and grade-single.sh executable
