<?php
//connect to the database
$connect = mysqli_connect("localhost","root","Zertodata1!");
mysqli_select_db($connect,"zerto"); //select the table

$result = mysqli_query($connect, "SHOW TABLES LIKE 'throughput'");

$exists = 0;
$exists = mysqli_num_rows($result);

if ($exists == 0) {
  echo "Creating the Database and loading historical data\r\n";
  // create throughput table in database
  $query = "CREATE TABLE `zerto`.`throughput` ( `time` DATETIME NOT NULL , `WriteMbps` FLOAT(20) NOT NULL ) ENGINE = InnoDB";
  $result = mysqli_query($connect, $query) or die (mysqli_error($connect));
  //build historical throughput table
  $query = "INSERT INTO throughput (time, WriteMbps) SELECT datestamp as time, ((SUM(KBWriteAvg) * 8) / 1024) as WriteMbps FROM `stats` GROUP By datestamp";
  $result = mysqli_query($connect, $query) or die (mysqli_error($connect));
}
else
{
  echo "\r\nTable already exists\r\n";
}
echo "\r\nAdding statint column to stats table if needed\r\n";

$query = "ALTER TABLE `stats` ADD `statint` INT(2) NOT NULL";
$result = mysqli_query($connect, $query) or die (mysqli_error($connect));
?>
