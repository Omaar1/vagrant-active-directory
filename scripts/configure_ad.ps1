param
(
    [string]$domainName = "redinvoke.local",
    [string]$domainNetbiosName = "RED",
    [string]$safeModePass = "P@ssw0rd"
)

Install-ADDSForest `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode Win2012R2 `
-DomainName "$domainName" `
-DomainNetbiosName "$domainNetbiosName" `
-ForestMode Win2012R2 `
-InstallDns `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion `
-SysvolPath "C:\Windows\SYSVOL" `
-SafeModeAdministratorPassword (ConvertTo-SecureString "$safeModePass" -AsPlainText -Force) `
-Force
