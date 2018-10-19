#!/usr/bin/pwsh
Write-Host "Generating list of all VMs in vCenter."

$Config = "/home/zerto/include/config.txt"
$Key = (3,4,2,3,56,34,254,222,1,1,2,23,42,54,33,233,1,34,2,7,6,5,35,43)
$env = get-content $Config | out-string | convertFrom-StringData
$env.password = $env.password | convertto-securestring -Key $Key
$mycreds = New-Object System.Management.Automation.PSCredential ($env.username, $env.password)
$session = Connect-VIServer -Server $env.vcenter -Credential $mycreds

Get-VM -Name * | Select Name | ConvertTo-Csv | Select -Skip 1 | Out-File /home/zerto/data/all-vms.csv

Write-Host "List Generation Compeleted"

Write-Host "Loading to Database"
/usr/bin/php /home/zerto/zplanner/loaders/loadvms.php
