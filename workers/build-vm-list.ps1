Write-Host "This script will get a list of all VMs in vCenter."
Write-Host "Edit /home/zerto/data/vmlist.csv to remove VMs that do not need monitored"

$Config = "/home/zerto/include/config.txt"
$Key = (3,4,2,3,56,34,254,222,1,1,2,23,42,54,33,233,1,34,2,7,6,5,35,43)
$env = get-content $Config | out-string | convertFrom-StringData
$env.password = $env.password | convertto-securestring -Key $Key
$mycreds = New-Object System.Management.Automation.PSCredential ($env.username, $env.password)
$session = Connect-VIServer -Server $env.vcenter -Credential $mycreds

Get-VM | Select Name | Export-CSV /home/zerto/data/vmlist.csv

Write-Host "List Generation Compeleted"
