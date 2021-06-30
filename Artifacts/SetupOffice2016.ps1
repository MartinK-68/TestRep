function Handle-LastError
{
    [CmdletBinding()]
    param(
    )

    $message = $error[0].Exception.Message
    if ($message)
    {
        Write-Host -Object "ERROR: $message" -ForegroundColor Red
        Write-Host -Object $error -ForegroundColor Red
    }
    
    # IMPORTANT NOTE: Throwing a terminating error (using $ErrorActionPreference = "Stop") still
    # returns exit code zero from the PowerShell script when using -File. The workaround is to
    # NOT use -File when calling this script and leverage the try-catch-finally block and return
    # a non-zero exit code from the catch block.
    exit -1
}
###################################################################################################
#
# PowerShell configurations
#

# NOTE: Because the $ErrorActionPreference is "Stop", this script will stop on first failure.
#       This is necessary to ensure we capture errors inside the try-catch-finally block.
$ErrorActionPreference = "Stop"

# Ensure we set the working directory to that of the script.
Push-Location $PSScriptRoot

###################################################################################################
#
# Handle all errors in this script.
#

trap
{
    # NOTE: This trap will handle all errors. There should be no need to use a catch below in this
    #       script, unless you want to ignore a specific error.
    $message = $error[0].Exception.Message
    if ($message)
    {
        Write-Host -Object "ERROR: $message" -ForegroundColor Red
    }
    
    # IMPORTANT NOTE: Throwing a terminating error (using $ErrorActionPreference = "Stop") still
    # returns exit code zero from the PowerShell script when using -File. The workaround is to
    # NOT use -File when calling this script and leverage the try-catch-finally block and return
    # a non-zero exit code from the catch block.
    Write-Host 'Artifact failed to apply.'
    exit -1
}

try
{
$Letter = "Q:"
$EncKey ="76492d1116743f0423413b16050a5345MgB8AFcAUwBsADQAZQBXAG8AMQB3AHMAKwBHAFoAZAB0AGIANQA2AEgATgAyAFEAPQA9AHwAZgAyADAAYgAzADAAOQBiADEAOABiADkANgA3ADkANgAwADMAMgBlADQAYQBiADMAYgAzADMAYQAyADkAMwA4AGYAYQBmADEAZQBlAGUAYQBhAGMAYwBmADEAMQA5ADAAOQ
BlADQANQBjADUAMAA0ADUAMwBmAGYANwA0AGEAOQBjADkAMABkADAAMQA2ADAAYQA0AGUAYQA0ADkAMQA1ADYANgAwAGYAMwBlAGMAZQBmADUANQBhAGEAYwA4ADYAMgBmADcAMwBhAGEAOABmADkAMwBjADIAZAA3AGUAYQBkAGEAYwBiADAAOABhAGIAMgBhAGMAMwBjADgAMgAzADQANABlADkAZABkADcAMABi
AGQAMgBlAGMANgBjADYAMgBjADQAZQAwAGQAMgAzAGIAMQBhADMAMwAxADEAOQBjADEAOQA2AGYAZABhADkAOQBiAGUANgBkADEANQAzAGQANQA5ADQAMQBjADUAMQA4ADYAMQA0AGIAYgAxADgANgAyADIAYgA5ADAAYwBjAGQAZQAwADQAYwBhADgANgAwADAAYQA2ADMAZgBkADIAZgA0ADAAOAAyADIAMQA5AD
MAMwA5AGUANgA3ADcAZgA3ADEAMAA1AGYANQAwADUAMgA1ADEANgA3ADgAMwAzAGMAZgA1ADMANQAxAGIAZQAwADEAZgA2ADEAYQA1AGYAZgBjAGMANABhADQAMQA1ADUANABhAGQAYQBmAGEAYgBhADgAMgA5ADkANQBjAGIANgBkADYAYQBhADgANgBkAGYAZgA0ADkANgAyADAANQAxADEAMQAzADgAMQBjADAA
ZAAxAGQAOAAwAGEAMABlADkAMgBmADAAZQBhAGUAMABiADgANABiAGIANABmAGEAOQBjADIAMgBiADAAOABlADkAMgBlADcANQA3AGEANgA3AGYAMAAxAGEAYgBmAGMAOQAwADEAMgAzADAANgBhAGQAMAA5ADQAYwA2AGQAOQA3AGUAYQAxAGQAMAA5AGIA"
$B = (36,188,148,62,90,211,196,70,128,166,118,239,75,25,16,39,72,173,163,175,116,141,99,132)
$SP = ConvertTo-SecureString -String $EncKey -Key $B
$aK = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SP)
$acctKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($aK)
[string]$user = 'sageazuredevtestlabs'

Invoke-Expression -Command "net use $Letter \\sageazuredevtestlabs.file.core.windows.net\sageazuredevtestlabs\shareddrive /user:sageazuredevtestlabs\$user $acctKey /persistent:no"


#install Office 2016
$TAFPath = "\\sageazuredevtestlabs.file.core.windows.net\sageazuredevtestlabs\shareddrive\Downloads\Microsoft\MicrosoftOffice\2016"
$TAFArgs = "c:\officeinstaller\OfficeSilentInstallconfig.xml"
$NewPath = "c:\officeinstaller\office\setup32.exe"

#md c:\officeinstaller 
copy-item $TAFPath  -Destination "c:\officeinstaller" -recurse -Force
Start-Process -FilePath $NewPath -ArgumentList $TAFArgs -Wait
Write-Host "Installed Microsoft Office 2016"

}
 
 finally
{
    Pop-Location
    Invoke-Expression -Command "net use $Letter /delete /y"
}