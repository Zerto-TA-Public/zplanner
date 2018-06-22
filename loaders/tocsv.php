<?php
//connect to the database
$csvfile = '/home/zerto/data/vmlist.csv';
$handle = fopen($csvfile, 'w') or die('Cannot open file:  '.$csvfile); //implicitly creates file
$line1 = '"Name"' . PHP_EOL;
fwrite($handle, $line1);

$connect = mysqli_connect("localhost","root","Zertodata1!");
mysqli_select_db($connect,"zerto"); //select the table

$vms = mysqli_query($connect, "SELECT * FROM `vms` WHERE `monitor` = 'Y' ORDER BY `name`") or die(mysqli_error($connect));
while($row = mysqli_fetch_assoc($vms)) {
	$data = '"' .  $row["name"] . '"' . PHP_EOL;
	fwrite($handle, $data);
}

