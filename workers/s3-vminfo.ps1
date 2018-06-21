$Config = "/home/zerto/include/config.txt"
$Key = (3,4,2,3,56,34,254,222,1,1,2,23,42,54,33,233,1,34,2,7,6,5,35,43)
$env = get-content $Config | out-string | convertFrom-StringData
$env.password = $env.password | convertto-securestring -Key $Key
$mycreds = New-Object System.Management.Automation.PSCredential ($env.username, $env.password)
$session = Connect-VIServer -Server $env.vcenter -Credential $mycreds


$startdir = "/home/zerto/data/"
$csvfile = "$startdir/vminfo.csv"
 
$myCol = @()
 
$list = Import-CSV "/home/zerto/data/vmlist.csv"

ForEach ($VM in $list){
 
$vmview = Get-VM -Name $VM.Name | Get-View
 
    $VMInfo = "" |select-Object VMName,NumCPU,MEMSize
    $VMInfo.VMName = $vmview.Name
    $VMInfo.NumCPU = $vmview.Config.Hardware.NumCPU
    $VMInfo.MEMSize = $vmview.Config.Hardware.MemoryMB

    $myCol += $VMInfo
}

disconnect-viserver $session -confirm:$false

$myCol | select "VMName", "NumCPU", "MEMSize" | Format-Table -AutoSize
$myCol | select "VMName", "NumCPU", "MEMSize" | ConvertTo-Csv | Select -Skip 1 | Out-File $csvfile

/usr/bin/php /home/zerto/zplanner/loaders/loadVMinfomysql.php vminfo.csv

Write-Host "VM CPU / Memory Info has been loaded into the Database"
Write-Host "Next Run contab -e and un-comment the scheduled tasks to start stats collection"
