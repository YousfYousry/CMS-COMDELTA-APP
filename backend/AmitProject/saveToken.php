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
	
	$token = $_POST["token"];
	$clientId = $_POST["client_id"];
	
	$activeSince = date('Y-m-d H:i:s', ($now - 64 * 60 * 60));
	$queryInActive = $connection-> query("SELECT * FROM devices WHERE LatestUpdateDate < '".$activeSince."'");

	
	$queryResult = $connection-> query("SELECT * FROM notification WHERE token = '".$token."'");
	if ($queryResult->num_rows == 0) {
		$sql = "INSERT INTO notification (token, client_id, inactiveDevices) VALUES ('".$token."', '".$clientId."', '".$queryInActive->num_rows."')";
		if(mysqli_query($connection, $sql)){
			echo json_encode("200");
			} else{
			echo "ERROR: Could not able to execute $sql. " . mysqli_error($connection);
		}
		}else{
			$sql ="UPDATE notification SET client_id = '".$clientId."' WHERE token = '".$token."'";
			if(mysqli_query($connection, $sql)){
				echo json_encode("200");
			} else{
				echo "ERROR: Could not able to execute $sql. " . mysqli_error($connection);
		}
}
	
	mysqli_close($connection);
?>
