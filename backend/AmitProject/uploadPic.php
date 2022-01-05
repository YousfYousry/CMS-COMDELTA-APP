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
	
    $image = $_POST['image'];
	$userId = $_POST['name'];
    $name =  "profilePic/".md5("gef" . $userId).'.jpg';
	
    file_put_contents($name, base64_decode($image));
	
	$sql = "UPDATE users SET logo = 'http://103.18.247.174:8080/AmitProject/".$name."' WHERE user_id = '".$userId."'";
	if ($connection->query($sql) === TRUE) {
		echo "0";
	}
	// echo json_encode('http://103.18.247.174:8080/AmitProject/".$name."');
	
	$connection->close();
	
?>
