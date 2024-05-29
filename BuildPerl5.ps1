<# NOTES
	Please use Developer PowerShell for VS (in Administrator mode)
#>

# /favor:<blend|AMD64|INTEL64|ATOM>
<# Makefile
	INST_DRV	= C:
	INST_TOP	= $(INST_DRV)\... (Prefix)
	CCTYPE		= MSVC143
	EXTRACFLAGS	= -nologo -GF -W3
	EXTRACFLAGS = $(EXTRACFLAGS) /favor:blend /O2
	EXTRACFLAGS = $(EXTRACFLAGS) /GR /guard:cf /guard:ehcont /GL /GA /GT
	EXTRACFLAGS = $(EXTRACFLAGS) /EHsc /Qpar /Qspectre-load-cf /Qspectre-jmp
	LINK_FLAGS = $(LINK_FLAGS) /LTCG
	LINK_FLAGS = $(LINK_FLAGS) /OPT:REF /OPT:ICF
#>


$SourceDir = "..." # Cloned Git Perl 5 Repository

cd $SourceDir\win32

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

cd $SourceDir
git reset --hard
git clean -fdx