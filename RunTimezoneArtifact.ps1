$svc_name = 'Network List Service'
Set-Service -StartupType Disabled $svc_name
$svc_name2 = 'Network Location Awareness'
Set-Service -StartupType Disabled $svc_name2
$svc_name3 = 'Error Reporting Service'
Set-Service -StartupType Disabled $svc_name3
