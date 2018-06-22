# Step one script

$Key = (3,4,2,3,56,34,254,222,1,1,2,23,42,54,33,233,1,34,2,7,6,5,35,43)

#Get Site vCenter Information
$vcenter = read-host -Prompt 'Enter vCenter IP Address'
$user = read-host -Prompt 'Enter vCenter Username'
$pass = read-host -assecurestring -Prompt 'Enter vCenter password' | convertfrom-securestring -Key $Key

$vcenter = "vcenter="+$vcenter
$vcenter | out-file /home/zerto/include/config.txt
$vcenter | out-file /home/zerto/include/config.ini -Append

$user = "username="+$user
$user | out-file /home/zerto/include/config.txt -Append

$pass = "password="+$pass
$pass | out-file /home/zerto/include/config.txt -Append

Write-Host "Information Written to Configuration files"
