#$svc_name = 'Network List Service'
#Set-Service -StartupType Disabled $svc_name
#$svc_name2 = 'Network Location Awareness'
#Set-Service -StartupType Disabled $svc_name2
#$svc_name3 = 'Error Reporting Service'
#Set-Service -StartupType Disabled $svc_name3
###################################################################################################

#
# PowerShell configurations
#

# NOTE: Because the $ErrorActionPreference is "Stop", this script will stop on first failure.
#       This is necessary to ensure we capture errors inside the try-catch-finally block.
$ErrorActionPreference = "Stop"

# Ensure we set the working directory to that of the script.
pushd $PSScriptRoot

###################################################################################################

#
# Functions used in this script.
#
$scriptFolder = "c:\buildArtifacts\Artifacts\TimeZone"
$b = Get-ChildItem -Path $scriptFolder
write-host $b
#$functionFiles = Get-ChildItem -Path $scriptFolder\* -Include '*artifact-funcs*.ps1' -Exclude '*.tests.ps1' 
.$scriptFolder\artifact-funcs.ps1
#foreach($file in $functionFiles)
#{
#    $fileName = $file.Name
#    ."./$fileName"
#    Write-Host($file.Name);
#}

###################################################################################################

#
# Handle all errors in this script.
#

trap
{
    # NOTE: This trap will handle all errors. There should be no need to use a catch below in this
    #       script, unless you want to ignore a specific error.
    #Handle-LastError
}

###################################################################################################

#
# Main execution block.
#

try
{
    #arguments passed to this script should be passed to the artifact script
    $command = $Script:MyInvocation.MyCommand
    $scriptName = $Script:MyInvocation.MyCommand.Name
    $scriptLine = $MyInvocation.Line
    
    $region = "GB"

    .$scriptFolder\artifact.ps1 -Region $region

    Write-Host 'Artifact installed successfully.'
}
finally
{
    popd
}
