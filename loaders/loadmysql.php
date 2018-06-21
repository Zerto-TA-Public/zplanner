<?php
$data = [];
$path = '/home/zerto/data/';
$csvfile = $argv[1];
$csvfile = $path.$csvfile;

//connect to the database
$connect = mysqli_connect("localhost","root","Zertodata1!");
mysqli_select_db($connect,"zerto"); //select the table
//

if (file_exists($csvfile) && filesize($csvfile) > 0) {

    //get the csv file
    $handle = fopen($csvfile,"r");

    //loop through the csv file and insert into database
while ($data = fgetcsv($handle,1000, ",", '"')) {
	echo "Row Data \n";
	echo $data[0] . " " . $data[1] . " " . $data[2] . " " . $data[3] . " " . $data[4] . " " . $data[5] . " " .$data[6] . "\n";
        if ( $data[1] ) {
		$writeIOAvg = 0;
		if ($data[4] != "0") {
			$writeIOAvg = $data[5] / $data[4];
		}
		if ($data[4] == 0) {
			$writeIOAvg = $data[5];
		}
		echo "Average Write IO Size " . $writeIOAvg . "\n\n";
            mysqli_query($connect, "INSERT INTO stats (VM, Disk, CapacityGB, IOPSReadAvg, IOPSWriteAvg, KBWriteAvg, KBReadAvg, writeIOAvgKB) VALUES
                (
                    '".addslashes($data[0])."',
                    '".addslashes($data[1])."',
                    '".addslashes($data[2])."',
                    '".addslashes($data[3])."',
                    '".addslashes($data[4])."',
                    '".addslashes($data[5])."',
                    '".addslashes($data[6])."',
		    '".$writeIOAvg."'
                )
            ") or die (mysqli_error($connect));
        }
    } 
    //

}
?>
