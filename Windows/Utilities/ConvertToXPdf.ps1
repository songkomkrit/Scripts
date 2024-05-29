param (
	[String] $Type="pdf", # pdf or x
    [Parameter(Mandatory=$true)] [String] $Path,
	[Bool] $Dry=$true
)

$LogFile = "$Path\Logs\logMSConvert.log"
if (-Not(Test-Path -Path $LogFile)) {
	New-Item -Path $LogFile -Force
}

function My-NewLine {
	param ([String] $Activity)
	Write-Output "`n==========================================="
	Write-Output $Activity
	Write-Output "===========================================`n"	
}

function My-WriteLog {
	param (
		[Parameter(Mandatory=$true)] [String] $LogPath,
		[string] $LogString
	)
	if (-Not(Test-Path -Path $LogPath)) {
		New-Item -Path $LogPath -Force
	}
	$DateTime = "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
	$LogMessage = "$Datetime $LogString"
	Add-content $LogPath -value $LogMessage
}

function Get-MSDllPath {
	param ([String] $Software)	# Word or PowerPoint	
	$dllMainDir = "C:\Windows\assembly\GAC_MSIL"
	$dllSubDir = "Microsoft.Office.Interop." + $Software
	$verToken = (Get-ChildItem -Path $dllMainDir\$dllSubDir).Name
	$dllSubDir += "\$verToken"
	$dllFile = "Microsoft.Office.Interop." + $Software + ".dll"	
	return [string]::Join('\', $dllMainDir, $dllSubDir, $dllFile)
}

Write-Host "`nInput Directory: $Path"
Write-Host "Full-Path Directory: $pwd\$Path"

if ($Type.ToLower() -eq "pdf") {
	Write-Host "`nConversion Mode: DOCX/PPTX to PDF"
} elseif ($Type.ToLower() -eq "x") {
	Write-Host "`nConversion Mode: DOC/PPT to DOCX/PPTX"
}
Write-Host "DRY RUN: $Dry"

$WordDLL = Get-MSDLLPath -Software "Word"
$PptDLL = Get-MSDLLPath -Software "PowerPoint"
Add-Type -AssemblyName $WordDLL
Add-Type -AssemblyName $PptDLL

if ($Type.ToLower() -eq "pdf") {
	$wordFiles = Get-ChildItem -Path $Path -Filter *.docx -Recurse
	$ppFiles = Get-ChildItem -Path $Path -Filter *.pptx -Recurse
	Add-content $LogFile -value "------------------------------------"
} elseif ($Type.ToLower() -eq "x") {
	$wordFiles = Get-ChildItem -Path $Path -Filter *.doc -Recurse
	$ppFiles = Get-ChildItem -Path $Path -Filter *.ppt -Recurse
	Add-content $LogFile -value "------------------------------------"
}

# MS Word
if ($Type.ToLower() -eq "pdf") {
	My-NewLine -Activity "Convert DOCX to PDF"
} elseif ($Type.ToLower() -eq "x") {
	My-NewLine -Activity "Convert DOC to DOCX"
}
$n = $wordFiles.Count
$count = 0
foreach ($wordFile in $wordFiles) {
	$count++
	Write-Host "WI ($count/$n) $wordFile"
	if ($Type.ToLower() -eq "pdf") {
		$outFile = $ppFile.FullName -replace ".docx", ".pdf"
	} elseif ($Type.ToLower() -eq "x") {
		$outFile = $ppFile.FullName -replace ".doc", ".docx"
	}
	$Success = $true
	$ExistPDF = Test-Path -Path $outFile
	if ($ExistPDF) {
		$Success = $false
		Write-Host "WE ($count/$n) $outFile`n"
	} elseif (-Not $Dry) {		
		try {
			$word = New-Object -ComObject Word.Application
			$document = $word.Documents.Open($wordFile.FullName)
			if ($Type.ToLower() -eq "pdf") {
				$document.SaveAs($outFile, `
					[Microsoft.Office.Interop.Word.WdSaveFormat]::wdFormatPDF)
			} elseif ($Type.ToLower() -eq "x") {
				$document.SaveAs($outFile, `
					[Microsoft.Office.Interop.Word.WdSaveFormat]::wdFormatDocumentDefault)
			}
			$document.Close()
			$word.Quit()
		}
		catch {
			$Success = $false
			Write-Host "W-Unsuccessful ($count/$n)`n"
			My-WriteLog -LogPath $LogFile `
				-LogString "W-Unsuccessful ($count/$n) $wordFile"
		}
	}
	
	if ($Success) {
		Write-Host "WO ($count/$n) $outFile`n"
	}
}

# MS PowerPoint
if ($Type.ToLower() -eq "pdf") {
	My-NewLine -Activity "Convert PPTX to PDF"
} elseif ($Type.ToLower() -eq "x") {
	My-NewLine -Activity "Convert PPT to PPTX"
}
$n = $ppFiles.Count
$count = 0
foreach ($ppFile in $ppFiles) {
	$count++
	Write-Host "PI ($count/$n) $ppFile"
	if ($Type.ToLower() -eq "pdf") {
		$outFile = $ppFile.FullName -replace ".pptx", ""
	} elseif ($Type.ToLower() -eq "x") {
		$outFile = $ppFile.FullName -replace ".ppt", ".pptx"
	}
	$Success = $true
	$ExistPDF = Test-Path -Path "$outFile.pdf"
	if ($ExistPDF) {
		$Success = $false
		Write-Host "PE ($count/$n) $outFile.pdf`n"
	} elseif (-Not $Dry) {
		try {
			$pp = New-Object -ComObject PowerPoint.Application
			$presentation = $pp.Presentations.Open($ppFile.FullName)
			if ($Type.ToLower() -eq "pdf") {
				$presentation.SaveAs($outFile, `
					[Microsoft.Office.Interop.PowerPoint.PpSaveAsFileType]::ppSaveAsPDF)
			} elseif ($Type.ToLower() -eq "x") {
				$presentation.SaveAs($outFile, `
					[Microsoft.Office.Interop.PowerPoint.PpSaveAsFileType]::ppSaveAsDefault)
			}
			$presentation.Close()
			$pp.Quit()
		}
		catch {
			$Success = $false
			Write-Host "P-Unsuccessful ($count/$n)`n"
			My-WriteLog -LogPath $LogFile `
				-LogString "P-Unsuccessful ($count/$n) $ppFile"
		}
	}
	
	if ($Success) {
		if ($Type.ToLower() -eq "pdf") {
			Write-Host "PO ($count/$n) $outFile.pdf`n"
		} elseif ($Type.ToLower() -eq "x") {
			Write-Host "PO ($count/$n) $outFile`n"
		}
	}
}

My-NewLine -Activity "DONE"