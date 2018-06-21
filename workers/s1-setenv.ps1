# Step one script

$Key = (3,4,2,3,56,34,254,222,1,1,2,23,42,54,33,233,1,34,2,7,6,5,35,43)

#Get Zerto SE Info
$am = read-host -Prompt 'Enter Zerto AM Name'
$se = read-host -Prompt 'Enter Zerto SE Name'

#Get Customer and Site Information
$company = read-host -Prompt 'Enter Customer Company Name'
$site = read-host -Prompt 'Enter Customer Site Name'
$custName = read-host -Prompt 'Enter Customer Contact Name'
$custEmail = read-host -Prompt 'Enter Customer Contact Email Address'

#Get Site vCenter Information
$vcenter = read-host -Prompt 'Enter vCenter IP Address'
$user = read-host -Prompt 'Enter vCenter Username'
$pass = read-host -assecurestring -Prompt 'Enter vCenter password' | convertfrom-securestring -Key $Key


#output info to config file
$am = "am="+$am
$am | out-file /home/zerto/include/config.ini

$se = "se="+$se
$se | out-file /home/zerto/include/config.ini -Append

$company = "company="+$company
$company | out-file /home/zerto/include/config.ini -Append

$site = "site="+$site
$site | out-file /home/zerto/include/config.ini -Append

$custName = "custName="+$custName
$custName | out-file /home/zerto/include/config.ini -Append

$custEmail = "custemail="+$custEmail
$custEmail | out-file /home/zerto/include/config.ini -Append

$vcenter = "vcenter="+$vcenter
$vcenter | out-file /home/zerto/include/config.txt
$vcenter | out-file /home/zerto/include/config.ini -Append

$user = "username="+$user
$user | out-file /home/zerto/include/config.txt -Append

$pass = "password="+$pass
$pass | out-file /home/zerto/include/config.txt -Append

Write-Host "Information Written to Configuration files"
