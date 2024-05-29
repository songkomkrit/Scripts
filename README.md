# Scripts

## Utilities
* **Convert DOC/PPT to DOCX/PPTX to PDF:** ConvertToXPdf.ps1

## Parallel Mode
* ```git clone -j<N> --recurse-submodules```
* ```msbuild <.sln_file> /m:<N> /p:Configuration=Release /p:Platform=x64 /p:SkipUWP=true```
* ```cmake --build . --config Release --target INSTALL --parallel <N>```

## Builds on Windows
* **Perl:** BuildPerl5.ps1
* **OpenSSL:** BuildOpenSSL.ps1
* **MongoDB C/C++ Drivers:** libmongocrypt.ps1 &rarr; mongo-c-driver.ps1 &rarr; mongo-cxx-driver.ps1

## Builds on Linux
