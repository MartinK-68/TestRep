Param(
	[Parameter(Mandatory=$False, Position=0, HelpMessage="keyvalue")]
	[string]$driveKey
)
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

###################################################################################################
#
# Main execution block.
#

try
{
#Allow Linked connections to allow share availability as Admin in UAC
$path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$name = 'EnableLinkedConnections'
$value = 1


IF(!(Test-Path $path))
{
New-Item -Path $path -Force | Out-Null
}

New-ItemProperty -Path $path -Name $name -Value $value `
-PropertyType DWORD -Force | Out-Null

$DriveLetter = 'Z'
#Start installing the share
$Letter = $DriveLetter+":"
$acctKey = $driveKey
[string]$user = 'sageazuredevtestlabs\sageazuredevtestlabs'

#Install Key for user running PS
#Invoke-Expression -Command "net use $Letter \\sageazuredevtestlabs.file.core.windows.net\sageazuredevtestlabs\shareddrive /user:$user $acctKey /persistent:no"

# Open Ports FireWall
# Commented out till Identify how to install on Win 7
# https://blogs.technet.microsoft.com/heyscriptingguy/2012/11/13/use-powershell-to-create-new-windows-firewall-rules/ or
# https://serverfault.com/questions/696963/set-netfirewallrule-alternative-in-windows-server-2008
#New-NetFirewallRule -DisplayName "Sage File Share In" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 137, 138, 139, 445
#New-NetFirewallRule -DisplayName "Sage File Share Out" -Direction Outbound -Action Allow -Protocol TCP -LocalPort 445

#Make file available for all users
New-Item "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\share.bat" -type file -force -value "
@echo off 
cmdkey /add:sageazuredevtestlabs.file.core.windows.net /user:$user /pass:$acctKey
net use $Letter \\sageazuredevtestlabs.file.core.windows.net\sageazuredevtestlabs\shareddrive /persistent:yes"

#Create link to fileshare on desktop for users
$wshshell = New-Object -ComObject WScript.Shell
$desktop = [System.Environment]::GetFolderPath('Desktop') 
$lnk = $wshshell.CreateShortcut($desktop+"\SharedDrive.lnk") 
$lnk.TargetPath ="\\sageazuredevtestlabs.file.core.windows.net\sageazuredevtestlabs\shareddrive"
$lnk.Save() 

}
finally
{
    Pop-Location
}