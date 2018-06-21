<?php
$data = [];
$path = '/home/zerto/data/';
$csvfile = $argv[1];
$csvfile = $path.$csvfile;

//connect to the database
$connect = mysqli_connect("localhost","root","Zertodata1!");
mysqli_select_db($connect,"zerto"); //select the table

if (file_exists($csvfile) && filesize($csvfile) > 0) {

    //get the csv file
    $handle = fopen($csvfile,"r");

    //loop through the csv file and insert into database
    while ($data = fgetcsv($handle,1000, ",", '"')) {
	$VMName = $data[0];
	$CPUs = $data[1];
	$MEM = $data[2];

	$result = mysqli_query($connect, "SELECT * FROM vminfo WHERE VMName ='$VMName' ");
	if( mysqli_num_rows($result) > 0) {
	    mysqli_query($connect, "UPDATE `vminfo` SET `NumCPU`= '$CPUs',`MemSize`= '$MEM' WHERE `VMName`='$VMName'") or die (mysqli_error($connect));
	}
	else
	{
	    mysqli_query($connect, "INSERT INTO vminfo (VMName, NumCPU, MemSize) VALUES ('$VMName', '$CPUs', '$MEM') ") or die (mysqli_error($connect));
	}
    }
}
?>
