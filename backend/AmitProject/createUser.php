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
	
	$email = "demo@demo.com";
	$password = "demo";
	$password_encrypted = md5("gef" . $password);
	
	
	$sql = "INSERT INTO user_login (username, password) VALUES ('".$email."', '".$password_encrypted."')";
	//$sql = "UPDATE user_login SET password =  '".$password_encrypted."' WHERE user_id = '112211'";
	
	$result="failed";
	if ($connection->query($sql) === TRUE) {
		$result="success";
	}
	
	echo json_encode($result);
?>
