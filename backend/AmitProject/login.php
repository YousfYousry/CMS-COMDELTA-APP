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
	
	$email = $_POST["email"];
	// $email = "unikl_bmi@comdelta.com";
	$password = $_POST["password"];
	// $password = "unikl_bmi";
	$password_encrypted = md5("gef" . $password);
	
	// echo ($email);
	//$sql = mysqli_query($connection, "SELECT count(*) as total from user_login WHERE username = '".$email."' and 
	//	password = '".$password_encrypted."' and user_type = 3");
	
	$sql = mysqli_query($connection, "SELECT * from user_login WHERE username = '".$email."' and 
	password = '".$password_encrypted."'");
	
	$row = mysqli_fetch_array($sql);
	
	$result = array();
	
	if($sql->num_rows == 1){
	    $result= array(
		'clientId' => $row['client_id'],
		'userId' => $row['user_id'],
		'type' => $row['user_type'],
		'res' => '0'
		);
		
		//		$result = $row["client_id"].','.$row["user_id"].','.$row["user_type"];
		}else{
		$result= array(
		'res' => '-1'
		);
	}
	echo json_encode($result);
	
	//$result = $connection->query("SELECT client_id from user_login WHERE username = '".$email."' and 
	//	password = '".$password_encrypted."' and user_type = 3");
	//if ($result->num_rows >0) {
	// output data of each row
	//  while($row = $result->fetch_assoc()) {
	//    echo $row["client_id"];
	//  }
	//} else {
	// echo 0;
	//}
	//$connection->close();
?>
