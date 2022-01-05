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
	
	$userId = $_POST["user_id"];
	$firstName = $_POST["first_name"];
	$lastName  = $_POST["last_name"];
	$email 	 = $_POST["email"];
	
	$sql = "UPDATE users SET first_name =  '".$firstName."' ,last_name = '".$lastName."'  WHERE user_id = '".$userId."'";
	$sql2 = "UPDATE user_login SET username = '".$email."' WHERE user_id = '".$userId."'";
	
	
	$result='-1';
	if ($connection->query($sql) === TRUE && $connection->query($sql2) === TRUE) {
		$result='0';
	}
	
	echo json_encode($result);
	
	$connection->close();
?>