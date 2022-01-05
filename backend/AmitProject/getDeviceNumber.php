<?php
    $servername = "localhost:3307";
    $username = "root";
    $password = "eWw8yk36Lh6977su";
    $dbname = "comd_light_ci";
	include 'admin/timeVar.php';

    $connection = new mysqli($servername, $username, $password, $dbname);
	if($connection ->connect_error){
        die("Connection Failed: " . $connection->connect_error);
        return;
	}
	header('Content-Type: application/json');
	
	//$clientId = 5;
	$clientId = $_POST["client_id"];
	$activeSince = date('Y-m-d H:i:s', ($now - 72 * 60 * 60));
	
	$queryTotal = $connection-> query("SELECT * FROM devices WHERE client_id = ".$clientId);
	$queryActive = $connection-> query("SELECT * FROM devices WHERE client_id = ".$clientId." AND LatestUpdateDate >= '".$activeSince."'");
	$queryInActive = $connection-> query("SELECT * FROM devices WHERE client_id = ".$clientId." AND LatestUpdateDate < '".$activeSince."'");
	
	echo json_encode($queryTotal->num_rows.','.$queryActive->num_rows.','.$queryInActive->num_rows);
?>
