<?php
    $servername = "localhost:3307";
    $username = "root";
    $password = "eWw8yk36Lh6977su";
    $dbname = "comd_light_ci";
	
    $connection = new mysqli($servername, $username, $password, $dbname);
	if($connection ->connect_error){
		die("Connection Failed: " . $connection->connect_error);
        return;
	}
	header('Content-Type: application/json');
	
	
	$deviceId = $_POST["device_id"];
	
	$result="-1";
	
	$sql = "DELETE FROM devices WHERE device_id = '".$deviceId."'";
	
	if ($connection->query($sql) === TRUE) {
		$result="0";
	}
	echo json_encode($result);
	$connection->close();
?>
