<?php
$data = [];
$csvfile = "/home/zerto/data/all-vms.csv";

//connect to the database
$connect = mysqli_connect("localhost","root","Zertodata1!");
mysqli_select_db($connect,"zerto"); //select the table


if (file_exists($csvfile) && filesize($csvfile) > 0) {

    //get the csv file
    $handle = fopen($csvfile,"r");

    //loop through the csv file and insert into database
echo "Row Data \n";

while ($data = fgetcsv($handle,1000, ",", '"')) {
	echo $data[0] . "\n";
        if ( $data[0] ) {
            mysqli_query($connect, "INSERT IGNORE INTO vms (name, monitor) VALUES
                (
                    '".addslashes($data[0])."',
                    'N'
                )
            ");
        }
    }
}
?>
