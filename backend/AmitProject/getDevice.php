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
	
	$clientId = $_POST["client_id"];
	//$devices = 'active';
	//$clientId = 5;
	$activeSince = date('Y-m-d H:i:s', ($now - 72 * 60 * 60));
	
	$str = "SELECT * FROM devices WHERE client_id = ".$clientId;
	
	if(isset($_POST["devices"])){
		$devices = $_POST["devices"];
		if($devices == 'active'){
			$str .= " AND LatestUpdateDate >= '".$activeSince."'";
			}else if($devices == 'inActive'){
			$str .= " AND LatestUpdateDate < '".$activeSince."'";
		}
	}
	
	$queryResult = $connection-> query($str);
	
	//echo $queryResult->num_rows;
	$result = array();
	if ($queryResult->num_rows > 0) {
		
		while ($fetchdata = $queryResult->fetch_assoc()) {
			$result[] = $fetchdata;
		}
		echo json_encode($result);
	}
?>
