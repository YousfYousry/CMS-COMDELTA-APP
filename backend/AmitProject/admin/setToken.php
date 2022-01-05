<?php
    $servername = "localhost:3307";
    $username = "root";
    $password = "eWw8yk36Lh6977su";
    $dbname = "comd_light_ci";
	include 'timeVar.php';

    $connection = new mysqli($servername, $username, $password, $dbname);
	if($connection ->connect_error){
        die("Connection Failed: " . $connection->connect_error);
        return;
	}
	header('Content-Type: application/json');
	
	$deviceIdentifier = $_POST["identifier"];
	$deviceModel = $_POST["model"];
	$token = $_POST["token"];
	$userType = $_POST["type"];
	$clientId = $_POST["client_id"];
	
	$queryResult = $connection-> query("SELECT * FROM phones WHERE device_identifier = '".$deviceIdentifier."'");
	if ($queryResult->num_rows == 0) {
		$sql = "INSERT INTO phones (device_identifier ,device_model, token, user_type, client_id) VALUES ('".$deviceIdentifier."', '".$deviceModel."', '".$token."', '".$userType."', '".$clientId."')";
		if(mysqli_query($connection, $sql)){
			echo json_encode("200");
			} else{
			echo "ERROR: Could not able to execute $sql. " . mysqli_error($connection);
		}
		}else{
			$sql ="UPDATE phones SET token = '".$token."', user_type = '".$userType."', client_id = '".$clientId."' WHERE device_identifier = '".$deviceIdentifier."'";
			if(mysqli_query($connection, $sql)){
				echo json_encode("200");
			} else{
				echo "ERROR: Could not able to execute $sql. " . mysqli_error($connection);
		}
}
	
	mysqli_close($connection);
?>
