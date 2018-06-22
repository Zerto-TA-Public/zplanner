<?php

$server = $_SERVER['SERVER_ADDR'];

?>

<html><head><body>
<h1><a href="http://<?php echo $server; ?>:3000/" >Stats Login Page</a></h1>
<hr>
<H2>Before Stats Collection will occur you need to select some VMs to monitor.</h2>
<h3><a href="monitor.php">Select VMs to Monitor</a></h1>
<h3><a href="unmonitor.php">Select VMs to STOP  Monitoring</a></h1>

