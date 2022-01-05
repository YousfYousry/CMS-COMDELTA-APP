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
	
	$userId =$_POST["user_id"];
	// $userId ='j2q3e0Po8hqMqkx';
	// SELECT
    // select_list
// FROM t1
// INNER JOIN t2 ON join_condition1
	$sql = mysqli_query($connection, "SELECT users.first_name,users.last_name,users.logo,user_login.username,user_login.client_id,user_login.status from users , user_login WHERE user_login.user_id = '".$userId."' AND users.user_id = '".$userId."'");
	// $sqlEmail = mysqli_query($connection, "SELECT user_login.user_id,user_login.username from user_login");
	
	// $result = "-1";
	// while($rowEmail = mysqli_fetch_array($sqlEmail)){
		// if($rowEmail["user_id"]==$userId){
			// while($row = mysqli_fetch_array($sqlName)){
				// if($row["user_id"]==$userId){
					// $result = $row["first_name"].','.$row["last_name"].','.$rowEmail["username"].','.$row["logo"];
					// break;
				// }
			// }
			// break;
		// }
	// }
	
	
	
	$row = mysqli_fetch_array($sql);
	
	$result = array();
	
	if($sql->num_rows == 1){
	    $result= array(
		'first_name' => $row['first_name'],
		'last_name' => $row['last_name'],
		'logo' => $row['logo'],
		'username' => $row['username'],
		'client_id' => $row['client_id'],
		'status' => $row['status'],
		'res' => '0'
		);
		}else{
		$result= array(
		'res' => '-1'
		);
	}
	echo json_encode($result);
	
?>
