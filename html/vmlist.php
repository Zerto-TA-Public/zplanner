<?php
    if ($_POST) {
        $vms_string = implode(', ', $_POST['vms']);
        $sql = 'UPDATE `vms` SET `monitor` = $_POST WHERE ('. $_POST['vmID'] .')';
	//connect to the database
	$connect = mysqli_connect("localhost","root","Zertodata1!");
	mysqli_select_db($connect,"zerto"); //select the table
        mysqli_query($connect, $sql) OR die(mysqli_error($connect));
    }
?>
<h1>Select the VMs that should be monitored</h1>
<p>The list is multi-select, select all VMs that Need Monitored then click Save</p>
<form method="post" action="">
VMs: <input type="text" name="vms"/> - 
<select name="vms[]" multiple="multiple">
    <option value="volvo">Volvo</option>
    <option value="saab">Saab</option>
    <option value="honda">Honda</option>
    <option value="audi">Audi</option>
    <option value="bmw">BMW</option>
</select>
<input type="submit" name="Submit"/>
</form>




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

