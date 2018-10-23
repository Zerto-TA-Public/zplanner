<?php

  //connect to the database
  $connect = mysqli_connect("localhost","root","Zertodata1!");
  mysqli_select_db($connect,"zerto"); //select the table

$result = mysqli_query($connect, 
		"UPDATE stats SET datestamp=(DATE_FORMAT(datestamp, '%Y-%m-%d %H:%i:00'))"
		) or die (mysqli_error($connect));
    
$exists = mysqli_num_rows($result); 

if (!$exists) {

  // create throughput table in database
  $query = "CREATE TABLE `throughput`";
  $result = mysqli_query($connect, $query) or die (mysqli_error($connect));

  //build historical throughput table
  $query = "SELECT datestamp as time, ((SUM(KBWriteAvg) / 1024) * 8) as       WriteMbps FROM `stats` GROUP By datestamp"
  $result = mysqli_query($connect, $query) or die (mysqli_error($connect));  


}
