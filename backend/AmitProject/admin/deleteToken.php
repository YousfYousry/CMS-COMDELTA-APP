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
	
	$deviceIdentifier = $_POST["identifier"];
	
	$queryResult = $connection-> query("SELECT * FROM phones WHERE device_identifier = '".$deviceIdentifier."'");
	if ($queryResult->num_rows == 0) {
	    echo json_encode("100");
		}else{
		$sql = "DELETE FROM phones WHERE device_identifier='".$deviceIdentifier."'";
		if(mysqli_query($connection, $sql)){
			echo json_encode("200");
			} else{
			echo "ERROR: Could not able to execute $sql. " . mysqli_error($connection);
		}
	}
	mysqli_close($connection);
?>
