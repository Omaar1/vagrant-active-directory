param
(
    [string]$domainName = "redinvoke.local"
)
Set-ADDefaultDomainPasswordPolicy $domainName -MinPasswordAge 0
Set-ADDefaultDomainPasswordPolicy $domainName -PasswordHistoryCount 0

