<?php

$server = $_SERVER['SERVER_ADDR'];

?>

<html><head><body>
<h1><a href="http://<?php echo $server; ?>:3000/" >Stats Login Page</a></h1>
<hr>
<H2>Before Stats Collection will occur you need to select some VMs to monitor.</h2>
<h3><a href="monitor.php">Select VMs to Monitor</a></h3>
<h3><a href="unmonitor.php">Select VMs to STOP  Monitoring</a></h3>
<hr>
<h3>VPG Designer</h3>
<p>This section will contain links for designing VPGs so that we can see how much throughput / Bandwidth will be needed for each.</p>
<hr>
<b><a href="phpmyadmin/">PHPMyAdmin</a></b> - For Exporting data or Importing VM lists (Zerto SE use)

