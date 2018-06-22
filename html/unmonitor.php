<?php
//connect to the database
$connect = mysqli_connect("localhost","root","Zertodata1!");
mysqli_select_db($connect,"zerto"); //select the table

if(isset($_POST['select_name'])){ // select_name will be replaced with your input filed name
	$getInput = $_POST['select_name']; // select_name will be replaced with your input filed name
	foreach ($getInput as $item => $id) {
			$update = mysqli_query($connect, "UPDATE `vms` SET `monitor` = 'N' WHERE `id` = $id") or die(mysqli_error($connect));
	}
}
?>
<html><title>UNMonitor VM Selection Page</title>
<body>
<h1>Select the VMs to stop monitoring then click monitor.</h1>
<p>Note that you can select some VMs and submit them, then repeat the process.</p>
<p>This list only contains <b>MONITORED</b> VMs.</p>
<p>To monitor VMs that are <b>NOT</b>currently being monitored click <a href="monitor.php">here</a></p>
<form action="" method="POST">
	<select name="select_name[]" id="" multiple size=30>
	<?php

	$vms = mysqli_query($connect, "SELECT * FROM `vms` WHERE `monitor` = 'Y' ORDER BY `name`") or die(mysqli_error($connect));
	while($row = mysqli_fetch_assoc($vms)) { ?>
		<option value="<?php echo $row["id"]; ?>"><?php echo $row["name"]; ?></option>
	<?php } ?>
	</select><br><br>
	<input type="submit" Value="STOP Monitoring">
</form>
