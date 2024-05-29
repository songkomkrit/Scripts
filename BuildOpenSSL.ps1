<# NOTES
	Please use Developer PowerShell for VS (in Administrator mode)
#>

$DevSourceDir = "..." # Source
$DevBuildDir = "..." # Build directory
$DevDestDir = "..." # Prefix

# /favor:<blend|AMD64|INTEL64|ATOM>
$DevClFlags = @"
	/favor:blend /O2 `
	/GR /guard:cf /guard:ehcont /GL /GA /GT `
	/EHsc /Qpar /Qspectre-load-cf /Qspectre-jmp
"@ -replace "`n",""

$DevLinkFlags = @"
	/LTCG `
	/OPT:REF /OPT:ICF `
	/DEBUG
"@ -replace "`n",""

$DevInclDir = "..." # Include directory (built from sources or vcpkg)
$DevLibDir = "..." # Library directory (built from sources or vcpkg)

New-Item -ItemType Directory -Path $DevBuildDir
cd $DevBuildDir

$Env:CFLAGS=$DevClFlags
$Env:CXXFLAGS=$DevClFlags
$Env:LDFLAGS=$DevLinkFlags

perl `
	$DevSourceDir\Configure VC-WIN64A-HYBRIDCRT `
	--prefix=$DevDestDir --openssldir=$DevDestDir\ssl `
	enable-egd enable-fips enable-tfo `
	threads enable-md2 enable-rc5 `
	enable-ktls `
	enable-acvp-tests `
	enable-crypto-mdebug enable-crypto-mdebug-backtrace `
	enable-trace enable-unstable-qlog `
	enable-brotli-dynamic zlib-dynamic enable-zstd-dynamic `
	enable-external-tests enable-unit-test `
	enable-ubsan `
	--with-brotli-include=$DevInclDir `
	--with-brotli-lib=$DevLibDir `
	--with-zlib-include=$DevInclDir `
	--with-zlib-lib=$DevLibDir `
	--with-zstd-include=$DevInclDir `
	--with-zstd-lib=$DevLibDir

$UseIcdbAgent = $true # Auxiliary initialization
$IcdbAgentPrevStatus = (Get-Service "Incredibuild_Agent").Status
if ($IcdbAgentPrevStatus -ne "Running") {
	try {
		Start-Service "Incredibuild_Agent" -ErrorAction Stop
	}
	catch {
		Write-Error -Message "The Incredibuild agent service cannot be started"
		$UseIcdbAgent = $false
	}
}

$BuildCmd = "nmake"
$InstallCmd = "nmake install"
if ($UseIcdbAgent) {
	BuildConsole /command=$BuildCmd
	BuildConsole /command=$InstallCmd
} else {
	Invoke-Expression $BuildCmd
	Invoke-Expression $InstallCmd
}

Set-Service "Incredibuild_Agent" -Status $IcdbAgentPrevStatus