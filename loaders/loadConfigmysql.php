<?php
$cfgfile = '/home/zerto/include/config.ini';

$config = parse_ini_file($cfgfile);

//print_r($config);

//connect to the database
$connect = mysqli_connect("localhost","root","Zertodata1!");
mysqli_select_db($connect,"zerto"); //select the table

if (file_exists($cfgfile) && filesize($cfgfile) > 0) {

	$Customer = $config['company'];
	$AM = $config['am'];
	$SE = $config['se'];
	$CustomerContact = $config['custName'];
	$CustomerEmail = $config['custemail'];
	$SiteName = $config['site'];
	$vCenter = $config['vcenter'];

	mysqli_query($connect, "INSERT INTO accountinfo (Customer, AM, SE, CustomerContact, CustomerEmail, SiteName, vCenter) 
		VALUES ('$Customer', '$AM', '$SE', '$CustomerContact', '$CustomerEmail', '$SiteName', '$vCenter') ") or die (mysqli_error($connect));
}
?>

