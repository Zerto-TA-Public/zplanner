#!/usr/bin/pwsh
$now=Get-Date -format "yyyyMMdd-HHmm"

function getvminfo {

$Config = "/home/zerto/include/config.txt"
$Key = (3,4,2,3,56,34,254,222,1,1,2,23,42,54,33,233,1,34,2,7,6,5,35,43)
$env = get-content $Config | out-string | convertFrom-StringData
$env.password = $env.password | convertto-securestring -Key $Key
$mycreds = New-Object System.Management.Automation.PSCredential ($env.username, $env.password)
$session = Connect-VIServer -Server $env.vcenter -Credential $mycreds
#/usr/bin/php /home/zerto/zplanner/loaders/tocsv.php

$startdir = "/home/zerto/data/"
$csvfile = "$startdir/vminfo.csv"
 
$myCol = @()
 
# merge all csv files into one big list
$list = Import-CSV "/home/zerto/data/vmlist0.csv"

if (Test-Path "/home/zerto/data/vmlist1.csv") {
$list += Import-CSV "/home/zerto/data/vmlist1.csv"
}
if (Test-Path "/home/zerto/data/vmlist2.csv") {
$list += Import-CSV "/home/zerto/data/vmlist2.csv"
}
if (Test-Path "/home/zerto/data/vmlist3.csv") {
$list += Import-CSV "/home/zerto/data/vmlist3.csv"
}
if (Test-Path "/home/zerto/data/vmlist4.csv") {
$list += Import-CSV "/home/zerto/data/vmlist4.csv"
}
if (Test-Path "/home/zerto/data/vmlist5.csv") {
$list += Import-CSV "/home/zerto/data/vmlist5.csv"
}
if (Test-Path "/home/zerto/data/vmlist6.csv") {
$list += Import-CSV "/home/zerto/data/vmlist6.csv"
}
if (Test-Path "/home/zerto/data/vmlist7.csv") {
$list += Import-CSV "/home/zerto/data/vmlist7.csv"
}
if (Test-Path "/home/zerto/data/vmlist8.csv") {
$list += Import-CSV "/home/zerto/data/vmlist8.csv"
}
if (Test-Path "/home/zerto/data/vmlist.csv") {
$list += Import-CSV "/home/zerto/data/vmlist9.csv"
}

ForEach ($VM in $list){
    $vmview = Get-VM -Name $VM.Name | Get-View
    $VMInfo = "" |select-Object VMName,NumCPU,MEMSize
    $VMInfo.VMName = $vmview.Name
    $VMInfo.NumCPU = $vmview.Config.Hardware.NumCPU
    $VMInfo.MEMSize = $vmview.Config.Hardware.MemoryMB
    echo $VMInfo.VMName
    $myCol += $VMInfo
}

disconnect-viserver $session -confirm:$false

$myCol | select "VMName", "NumCPU", "MEMSize" | Format-Table -AutoSize
$myCol | select "VMName", "NumCPU", "MEMSize" | ConvertTo-Csv | Select -Skip 1 | Out-File $csvfile

/usr/bin/php /home/zerto/zplanner/loaders/loadVMinfomysql.php vminfo.csv

Write-Host "VM CPU / Memory Info has been loaded into the Database"

}

$file = "/home/zerto/logs/" + $now + "-vminfo.log"

getvminfo *> $file

