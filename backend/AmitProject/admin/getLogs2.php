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
	$connection->db->params['charset'] = 'UTF8';
	$deviceId = "355";
	//	$offset = $_POST["offset"];
	//	$limit = $_POST["limit"];
	//	$searchTerm = $_POST["search_term"];

	$queryResult = $connection-> query("SELECT * FROM logdatastest WHERE device_id = '".$deviceId."' ORDER BY CreateDate DESC");
	//ORDER BY CreateDate DESC LIMIT ".$limit." OFFSET ".$offset."");

	$result = array();
	if ($queryResult->num_rows > 0) {
		while ($fetchdata = $queryResult->fetch_assoc()) {
			$result[] = $fetchdata;
		}
		echo json_encode($result,JSON_PARTIAL_OUTPUT_ON_ERROR );
	}
	
?>
