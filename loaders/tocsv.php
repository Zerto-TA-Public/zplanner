<?php

$csvpath = '/home/zerto/data/';

//delete old CSV files
for ($i = 0; $i < 10; $i++) {
        $file = $csvpath . "vmlist" . $i . ".csv";
        //need to add if statement to see if it exists before deleteing
	if (file_exists($file)) {
	    unlink($file);
	}
}

//connect to the database

$connect = mysqli_connect("localhost","root","Zertodata1!");
mysqli_select_db($connect,"zerto"); //select the table

// get the total number of VMs to be monitored and store in count
$result = mysqli_query($connect, "SELECT * FROM `vms` WHERE `monitor` = 'Y'") or die(mysqli_error($connect));
$count = mysqli_num_rows($result) or die(mysqli_error($connect));
echo $count . PHP_EOL;
// if monitoring 30 vms or less only use 1 worker
if ($count < 30) {
        // store all vms in vmlist0
        $csvfile = $csvpath . "vmlist0.csv";
        echo $csvfile . PHP_EOL;
        $handle = fopen($csvfile, 'w') or die('Cannot open file:  '.$csvfile); //implicitly creates file
        // write header to csv file
        $line1 = '"Name"' . PHP_EOL;
        fwrite($handle, $line1);

        //go get the VM names from mysql and put them in Csv
        $vms = mysqli_query($connect, "SELECT `name` FROM `vms` WHERE `monitor` = 'Y' ORDER BY `name`") or die(mysqli_error($connect));
        while($row = mysqli_fetch_assoc($vms)) {
                $data = '"' .  $row["name"] . '"' . PHP_EOL;
                fwrite($handle, $data);
        }
} else {

        // if we have more than 25 vms then we need to figure out how many VMs each worker will have to do. SO total vm count / 10 = number per worker
        $perworker = ceil($count / 10);
        for ($i = 0; $i < 10; $i++) {
                // create a csv file with a 1-10 number before the extension
                $csvfile = "vmlist" . $i . ".csv";
                $csvfile = $csvpath . $csvfile;
                echo $csvfile . PHP_EOL;
                $handle = fopen($csvfile, 'w') or die('Cannot open file:  '.$csvfile); //implicitly creates file
                // write header to csv file
                $line1 = '"Name"' . PHP_EOL;
                fwrite($handle, $line1);
                // figure out where mysql should start looking for VMs
                $x = $i * $perworker;
                // get the right vms to put in this csv file and write them to the csv
                $vms = mysqli_query($connect, "SELECT `name` FROM `vms` WHERE `monitor` = 'Y' ORDER BY `name` LIMIT $x, $perworker") or die(mysqli_error($connect));
                while($row = mysqli_fetch_assoc($vms)) {
                        $data = '"' .  $row["name"] . '"' . PHP_EOL;
                        fwrite($handle, $data);
                }
        }
}



