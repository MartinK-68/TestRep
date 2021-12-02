Write-Host "Running Artifact Install .net3.5"
#Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#Start-Sleep -s 20
#choco install dotnet3.5 -y
#Start-Sleep -s 20
#Get-Content -Path C:\ProgramData\chocolatey\logs\chocolatey.log
Dism /online /Enable-Feature /FeatureName:"NetFx3" /all
Write-Host "Completed Artifact Install .net3.5"
