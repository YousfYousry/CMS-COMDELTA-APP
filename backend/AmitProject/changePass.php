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
	$email = $_POST["email"];
	$password = $_POST["password"];
	$newPassword = $_POST["new_password"];
	
	$passwordEncrypted = md5("gef" . $password);
	$newPasswordEncrypted = md5("gef" . $newPassword);
	
	$sql = "UPDATE user_login SET password =  '".$newPasswordEncrypted."'  WHERE user_id = '".$userId."' and username = '".$email."' and password = '".$passwordEncrypted."'";
	
	$connection->query($sql);
	
	echo json_encode($connection -> affected_rows);
	
?>
