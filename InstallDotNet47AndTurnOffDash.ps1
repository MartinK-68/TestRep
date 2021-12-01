Write-Host "Running Artifact Install .net47"
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45 -All
Enable-WindowsOptionalFeature -Online -FeatureName WCF-HTTP-Activation45 -All
Enable-WindowsOptionalFeature -Online -FeatureName WCF-TCP-Activation45 -All
Enable-WindowsOptionalFeature -Online -FeatureName WCF-Pipe-Activation45 -All
Enable-WindowsOptionalFeature -Online -FeatureName WCF-MSMQ-Activation45 -All
Enable-WindowsOptionalFeature -Online -FeatureName WCF-TCP-PortSharing45 -All
Write-Host "Completed Artifact Install .net47"

Write-Host "Running Artifact Turn off server dashboard"
Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask -Verbose
Write-Host "Completed Artifact Turn off server dashboard"