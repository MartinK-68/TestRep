Param(
$SQLVersion = '2019',
$InstanceName = 'MSSQLSERVER',
$AnalysisService = 'true',
$IntergrationService = 'true',
$ReportingService = 'true',
$Tools = 'true',
$Password = 'Password!1',
$CollationMethod = 'Latin1_General_CI_AS'
)
Write-Host "Parameters: SQLVersion = $SQLVersion, Instance Name = $InstanceName, AS = $AnalysisService, IS = $IntergrationService, RS = $ReportingService, Tools = $Tools, Collation Method = $CollationMethod"

# Main execution block.
#

# set-ExecutionPolicy unrestricted -Force
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted


try
{

#Installs SQL Server locally with standard settings for Developers/Testers.
#Install SQL from command line help - https://msdn.microsoft.com/en-us/library/ms144259.aspx
$currentUserName = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name;
$winVerString = (Get-WmiObject Win32_OperatingSystem).Caption
Write-Host "Current user is: $currentUserName, Windows Version: $winVerString"

if ($winVerString -like 'Microsoft Windows Server 2008 R2*')
{
Write-Host "Server 2008 R2 and below not supported"
exit 1
}


$Domain = (Get-WmiObject Win32_ComputerSystem).domain
$Computer = (Get-WmiObject Win32_ComputerSystem).name
Write-Host "Domain: $Domain, Computer: $Computer"

If($Domain = 'WORKGROUP')
{
$sqlUsers = "BUILTIN\Administrators"
$sqlUsers2 = "$CurrentUserName"
$sqlUsers3 = "$Computer\SageAdmin"
}
Else
{
$sqlUsers = "$Domain\Domain Admins"
$sqlUsers2 = "$CurrentUserName"
$sqlUsers3 = "$Domain\SageAdmin"
}

# Note this command removes the fileshare which then gets recreated.
net use * /delete /yes 

$Letter = "Q:"
$acctKey = "Ms0oVnUEgUINEvPI9EisoTvhA/cUH8MPWhwx+I53z+pp+oPUFZ+uAtLmpN0RuZYzH91jLOEn0zDZ7FtkKtCMPQ=="
[string]$user = 'sageazuredevtestlabs'
Invoke-Expression -Command "net use $Letter \\sageazuredevtestlabs.file.core.windows.net\sageazuredevtestlabs\shareddrive /user:sageazuredevtestlabs\$user $acctKey /persistent:no"


Write-Host 'Installing 2019'
$SqlServerIsoImagePath = "Q:\Downloads\Microsoft\SQL Server 2019 Developer Edition\en_sql_server_2019_developer_x64_dvd_e5ade34a.iso"
$FileInit = "/SQLSVCINSTANTFILEINIT=""True"""
$vpath = '150'


#Additional Feature installation

if($AnalysisService -eq 'True')
{
$AS = ",AS"

$ASAdmin = "/ASSysAdminAccounts=""$sqlUsers3"""
$ASAccount = "/ASSVCACCOUNT=""NT Service\MSSQLServerOLAPService"""

#$ASAccountPassword = "/ASSVCPASSWORD=""************"""
Write-Host "ADmin Group: $ASAdmin, Service Account: $ASAccount"
}

if($IntergrationService -eq 'True')
{
if($SQLVersion -eq '2012')
{
$IS = ",IS"
$ISAccount = "/ISSVCACCOUNT=""NT Service\MsDtsServer110"""
}
elseif($SQLVersion -eq '2019')
{
$IS = ",IS"
$ISAccount = "/ISSVCACCOUNT=""NT Service\MsDtsServer150"""
}
elseif($SQLVersion -eq '2017')
{
$IS = ",IS"
$ISAccount = "/ISSVCACCOUNT=""NT Service\MsDtsServer140"""
}
elseif($SQLVersion -eq '2016')
{
$IS = ",IS"
$ISAccount = "/ISSVCACCOUNT=""NT Service\MsDtsServer130"""
}
elseif($SQLVersion -eq '2014')
{
$IS = ",IS"
$ISAccount = "/ISSVCACCOUNT=""NT Service\MsDtsServer120"""
}
}

if($ReportingService -eq 'True')
{
$RS = ",RS"
$RSAccount = "/RSSVCACCOUNT=""NT Service\ReportServer"""
}

if($Tools -eq 'True')
{
$Tools = ",Tools"
}

#Mount the installation media, and change to the mounted Drive.
$mountVolume = Mount-DiskImage -ImagePath $SqlServerIsoImagePath -PassThru
$driveLetter = ($mountVolume | Get-Volume).DriveLetter
$drivePath = $driveLetter+":"
push-location -path "$drivePath"
Write-Host "Drive mounted $drivePath"

#Install SQL Server locally with our default settings. 
# Only the Sql Engine and LocalDB
# i.e. no Replication, FullText, Data Quality, PolyBase, R, AnalysisServices, Reporting Services, Integration service, Master Data Services, Books Online(BOL) or SDK are installed.


.\Setup.exe /q /ACTION=Install /FEATURES=SQL$AS$IS$RS$Tools /ASSERVERMODE=MULTIDIMENSIONAL /UpdateEnabled="False" /UpdateSource=MU /X86=false /INSTANCENAME=$InstanceName /INSTALLSHAREDDIR="C:\Program Files\Microsoft SQL Server" /INSTALLSHAREDWOWDIR="C:\Program Files (x86)\Microsoft SQL Server" $FileInit /INSTANCEDIR="C:\Program Files\Microsoft SQL Server" /AGTSVCACCOUNT="NT Service\SQLSERVERAGENT" /AGTSVCSTARTUPTYPE="Manual" /SQLSVCSTARTUPTYPE="Automatic" /SQLCOLLATION="$CollationMethod" /SQLSVCACCOUNT="NT Service\MSSQLSERVER" /SQLSVCSTARTUPTYPE="Automatic" /SECURITYMODE="SQL" /SAPWD="$Password" $ASAdmin /SQLSYSADMINACCOUNTS=$sqlUsers $sqlUsers2 $sqlUsers3 /IACCEPTSQLSERVERLICENSETERMS $ISAccount $RSAccount

#Configure Firewall Policy
New-NetFirewallRule -DisplayName "Sage SQL Server 1433" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 1433

#Enable Named Pipes and TCP 
#Set and import SQL PS Module
$env:PSModulePath = $env:PSModulePath + ";C:\Program Files (x86)\Microsoft SQL Server\$vpath\Tools\PowerShell\Modules"

Install-Module SqlServer -AllowClobber
Import-Module -Name SqlServer
#Import-Module sqlps -DisableNameChecking - ***Deprecated***

# $smo = 'Microsoft.SqlServer.Management.Smo.'  
# $wmi = new-object ($smo + 'Wmi.ManagedComputer').  

## List the object properties, including the instance names.  
# $Wmi  

## Enable the TCP protocol on the default instance.  
# $uri = "ManagedComputer[@Name='" + (get-item env:\computername).Value + "']/ServerInstance[@Name='$InstanceName']/ServerProtocol[@Name='Tcp']"
# $Tcp = $wmi.GetSmoObject($uri)  
# $Tcp.IsEnabled = $true  
# $Tcp.Alter()  
# $Tcp  

## Enable the named pipes protocol for the default instance.  
# $uri = "ManagedComputer[@Name='" + (get-item env:\computername).Value + "']/ServerInstance[@Name='$InstanceName']/ServerProtocol[@Name='NP']"
# $Np = $wmi.GetSmoObject($uri)  
# $Np.IsEnabled = $true  
# $Np.Alter()  
# $Np 



#Restart SQL
net stop $InstanceName /y
Start-Sleep -s 30
net start $InstanceName /f /m

}
finally
{
    #Cleanup
    Pop-Location
    
    #Dismount the installation media.
    Dismount-DiskImage -ImagePath $SqlServerIsoImagePath
    Invoke-Expression -Command "net use $Letter /delete /y"
}

