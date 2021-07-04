New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft' -Name 'InputPersonalization' -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization' -PropertyType DWord -Name 'AllowInputPersonalization' -Value 0 -Force 
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore' -Name 'Settings' -Force
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings' -Name 'OnlineSpeechPrivacy' -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings' -PropertyType DWord -Name 'HasAccepted' -Value 1 -Force 
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Input' -Name 'TIPC' -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Input\TIPC' -PropertyType DWord -Name 'Enabled' -Value 0 -Force 
New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies' -Name 'TextInput' -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput' -PropertyType DWord -Name 'AllowLinguisticDataCollection' -Value 0 -Force
New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager' -Name 'ConsentStore' -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore' -PropertyType String -Name 'location' -Value Deny -Force
New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -Name 'AdvertisingInfo' -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -PropertyType DWord -Name 'Enabled' -Value 0 -Force
New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Settings' -Name 'FindMyDevice' -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Settings\FindMyDevice' -PropertyType DWord -Name 'LocationSyncEnabled' -Value 0 -Force
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion' -Name 'Privacy' -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy' -PropertyType DWord -Name 'TailoredExperiencesWithDiagnosticDataEnabled' -Value 0 -Force
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows' -Name 'OOBE' -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE' -PropertyType DWord -Name 'DisablePrivacyExperience' -Value 1 -Force
New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion' -Name 'UserProfileEngagement' -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement' -PropertyType DWord -Name 'ScoobeSystemSettingEnabled' -Value 0 -Force