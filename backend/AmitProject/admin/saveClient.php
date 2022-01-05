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
	
	$addEdit = $_POST["add_edit"];
	$clientName = $_POST["client_name"];
	$newClientName = $_POST["new_client_name"];
	$address = $_POST["address"];
	$contactNo = $_POST["contact_no"];
	$email = $_POST["email"];
	$active = $_POST["active"];
	$inactive = $_POST["inactive"];
	$userId = $_POST["user_id"];
	$createdBy="";
	$CreatedDate=date('Y-m-d H:i:s', ($now));
	
	$result="-1";
	
	do {
		$sql = "SELECT username FROM user_login WHERE user_id='".$userId."'";
		$admin = mysqli_query($connection, $sql);
		if (mysqli_num_rows($admin) == 1) {
			while($row = mysqli_fetch_assoc($admin)) {
				$createdBy=$row["username"];
			}
			}else{
			$result="2";
			break;
		}
		
		if($addEdit=="add"){
			$newClientExist = $connection->query("SELECT client_id FROM clients WHERE client_name = '".$newClientName."'");
			if($newClientExist->num_rows > 0) {
				$result="1";
				break;
			}
			
			$sql = "INSERT INTO clients (client_name, client_address, client_contact, client_email, stat_two, stat_three, CreatedBy, CreatedDate) 
			VALUES ('".$newClientName."', '".$address."','".$contactNo."','".$email."','".$active."','".$inactive."','".$createdBy."','".$CreatedDate."')";
			
			if ($connection->query($sql) === TRUE) {
				$result="0";
				break;
			}
			}else if($addEdit=="edit"){
			$clientExist = $connection->query("SELECT client_id FROM clients WHERE client_name = '".$clientName."'");
			if($clientExist->num_rows < 1) {
				$result="3";
				break;
			}

			$sql = "UPDATE clients SET client_name = '".$newClientName."',client_address = '".$address."',client_contact = '".$contactNo."'
			,client_email = '".$email."',stat_two = '".$active."',stat_three = '".$inactive."',ModifiedBy = '".$createdBy."',
			ModifiedDate = '".$CreatedDate."' WHERE client_name = '".$clientName."'";
			
			if ($connection->query($sql) === TRUE) {
				$result="10";
				break;
			}
		}
	} while (false);
	echo json_encode($result);
	$connection->close();
?>
