<?php

$csvpath = '/home/zerto/data/';

//delete old CSV files
for ($i = 0; $i < 10; $i++) {
	$file = $csvpath . "vmlist" . $i . ".csv";
	unlink($file);
	echo "Deleted " . $file . PHP_EOL;
}

//connect to the database

$connect = mysqli_connect("localhost","root","Zertodata1!");
mysqli_select_db($connect,"zerto"); //select the table

$result = mysqli_query($connect, "SELECT * FROM `vms` WHERE `monitor` = 'Y'") or die(mysqli_error($connect));
$count = mysqli_num_rows($result) or die(mysqli_error($connect));
echo $count . PHP_EOL;
if ($count < 26) {
	$csvfile = $csvpath . "vmlist0.csv";
	echo $csvfile . PHP_EOL;
	$handle = fopen($csvfile, 'w') or die('Cannot open file:  '.$csvfile); //implicitly creates file
	$line1 = '"Name"' . PHP_EOL;
	fwrite($handle, $line1);

	$vms = mysqli_query($connect, "SELECT `name` FROM `vms` WHERE `monitor` = 'Y' ORDER BY `name`") or die(mysqli_error($connect));
	while($row = mysqli_fetch_assoc($vms)) {
		$data = '"' .  $row["name"] . '"' . PHP_EOL;
		fwrite($handle, $data);
	}
} else {
	$perworker = ceil($count / 10);
	for ($i = 0; $i < 10; $i++) {
		$csvfile = "vmlist" . $i . ".csv";
		$csvfile = $csvpath . $csvfile;
		echo $csvfile . PHP_EOL;
		$handle = fopen($csvfile, 'w') or die('Cannot open file:  '.$csvfile); //implicitly creates file
		$line1 = '"Name"' . PHP_EOL;
		fwrite($handle, $line1);
		$x = $i * $perworker;
		$vms = mysqli_query($connect, "SELECT `name` FROM `vms` WHERE `monitor` = 'Y' ORDER BY `name` LIMIT $x, $perworker") or die(mysqli_error($connect));
        	while($row = mysqli_fetch_assoc($vms)) {
	               	$data = '"' .  $row["name"] . '"' . PHP_EOL;
                	fwrite($handle, $data);
		}
        }
}

