<?php
$connect = mysqli_connect("localhost","root","Zertodata1!");
mysqli_select_db($connect,"zerto"); //select the table

        $getdate = "SELECT datestamp FROM `stats` GROUP BY datestamp DESC LIMIT 1";
        $date = mysqli_query($connect, $getdate) or die (mysqli_error($connect));
        $date = $date->fetch_array();
        $date = $date['datestamp'];
        echo $date;
        $getmbps = "SELECT (SUM(`KBWriteAvg`) * 8 / 1000) as mbps FROM `stats` WHERE datestamp = '$date'";
        $mbps = mysqli_query($connect, $getmbps) or die (mysqli_error($connect));
        $mbps = $mbps->fetch_array();
        $mbps = $mbps['mbps'];
        echo $mbps;
        mysqli_query($connect,
                "INSERT INTO `throughput` (time, WriteMbps) VALUES ( '$date', '$mbps')"
                ) or die (mysqli_error($connect));
?>
