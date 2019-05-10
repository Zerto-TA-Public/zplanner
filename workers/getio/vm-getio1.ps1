#!/usr/bin/pwsh
$now=Get-Content "/home/zerto/include/datetime.txt"

function getio {
$Config = "/home/zerto/include/config.txt"
$Key = (3,4,2,3,56,34,254,222,1,1,2,23,42,54,33,233,1,34,2,7,6,5,35,43)
$csvPath = "/home/zerto/data/stats1.csv"
$vmlist = "/home/zerto/data/vmlist1.csv"


if ((Test-Path $vmlist -PathType Leaf)) {
Write-Host "CSV Exists ... getting Stats ..."

$env = get-content $Config | out-string | convertFrom-StringData
$env.password = $env.password | convertto-securestring -Key $Key
$mycreds = New-Object System.Management.Automation.PSCredential ($env.username, $env.password)
Import-Module -Name /home/zerto/zplanner/modules/get-vmmaxiops.psm1
$session = Connect-VIServer -Server $env.vcenter -Credential $mycreds
	
$list = Import-CSV $vmlist
$int = Get-Content "/home/zerto/include/interval.txt"
if ( !$int ) {
	$int = 5;
}

ForEach ($vm in $list){
	$report += Get-VM -Name $vm.Name | Get-VMmaxIOPS -Minutes $int
}
disconnect-viserver $session -confirm:$false

$report | select "VM", "Disk", "CapacityGB", "IOPSReadAvg", "IOPSWriteAvg", "KBWriteAvg", "KBReadAvg" | ConvertTo-Csv | Select -Skip 1 | Out-File $csvPath

/usr/bin/php /home/zerto/zplanner/loaders/loadmysql.php stats1.csv

} 
else {
Write-Host "No CSV File Found" 
}

}

$file = "/home/zerto/logs/" + $now + "-getio1.log"

getio *> $file
