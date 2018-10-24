<?php
$data = [];
$path = '/home/zerto/data/';
$csvfile = $argv[1];
$csvfile = $path.$csvfile;
$datefilepath = '/home/zerto/include/datetime.txt';
$intfilepath = '/home/zerto/include/interval.txt';

//connect to the database$datefilepath = '/home/zerto/include/datetime.txt';

$datefile = fopen($datefilepath, "r") or die("Unable to open file!");
$datestamp =  fgets($datefile);
fclose($datefile);

$intfile = fopen($intfilepath, "r") or die("Unable to open file!");
$interval =  fgets($intfile);
fclose($intfile);

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
            mysqli_query($connect, "INSERT INTO stats (datestamp, VM, Disk, CapacityGB, IOPSReadAvg, IOPSWriteAvg, KBWriteAvg, KBReadAvg, writeIOAvgKB, statint) VALUES
                (
		    '$datestamp',
                    '".addslashes($data[0])."',
                    '".addslashes($data[1])."',
                    '".addslashes($data[2])."',
                    '".addslashes($data[3])."',
                    '".addslashes($data[4])."',
                    '".addslashes($data[5])."',
                    '".addslashes($data[6])."',
		    '".$writeIOAvg."',
		    '$interval',
                )
            ") or die (mysqli_error($connect));
        }
    } 
}
?>
