# Scripts

## Utilities
* **Convert DOC/PPT to DOCX/PPTX to PDF:** ConvertToXPdf.ps1

## Parallel Mode
* ```git clone -j<N> --recurse-submodules```
* ```git pull -j<N> --recurse-submodules```
* ```msbuild <.sln_file> /m:<N> /p:Configuration=Release /p:Platform=x64 /p:SkipUWP=true```
* ```msbuild <.sln_file> /m:<N> /p:Configuration=Debug /p:Platform=x64 /p:SkipUWP=true```
* ```cmake --build . --config Release --target INSTALL --parallel <N>```
* ```cmake --build . --config Debug --target INSTALL --parallel <N>```
* ```make -j<N>```
* ```make -j<N> install```
* ```mingw32-make -j<N>```
* ```mingw32-make -j<N> install```

## Useful Commands
* ```git reset --hard --recurse-submodules```
* ```git clean --dry-run -fdx```
* ```git clean -fdx```

## Builds on Windows
* **Perl:** BuildPerl5.ps1
* **OpenSSL:** BuildOpenSSL.ps1
* **MongoDB C/C++ Drivers:** libmongocrypt.ps1 &rarr; mongo-c-driver.ps1 &rarr; mongo-cxx-driver.ps1

## Builds on Linux
