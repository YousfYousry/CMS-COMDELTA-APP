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
	
	$queryResult = $connection-> query("SELECT client_name FROM clients");
	
	$result = array();
	if ($queryResult->num_rows > 0) {
		
		while ($fetchdata = $queryResult->fetch_assoc()) {
			$result[] = $fetchdata;
		}
		echo json_encode($result);
	}
?>
