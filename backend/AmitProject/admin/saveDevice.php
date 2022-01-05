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
	
	$addEdit = $_POST['add_edit'];
	$quantity  = (int)$_POST['quantity'];
	$id = $_POST['device_id'];
	$client = $_POST['client'];
	$location = $_POST['location'];
	$deviceName = $_POST['device_name'];
	$deviceDetail = $_POST['device_detail'];
	$latitude = $_POST['latitude'];
	$longitude = $_POST['longitude'];
	$height = $_POST['height'];
	$activationDate = $_POST['activation_date'];
	$siteRegion = $_POST['site_region'];
	$batchNum = $_POST['batch_num'];
	$serialNum = $_POST['serial_num'];
	$simProvider = $_POST['sim_provider'];
	$batteryStatus = $_POST['battery_status'];
	$rssiStatus = $_POST['rssi_status'];
	$userId  = $_POST['user_id'];
	$createdBy = "";
	//	$createdId = "";
	$CreatedDate = date('Y-m-d H:i:s', ($now));
	
	$result="-1";
	
	
	$sql = "SELECT username FROM user_login WHERE user_id='".$userId."'";
	$admin = mysqli_query($connection, $sql);
	if (mysqli_num_rows($admin) == 1) {
		while($row = mysqli_fetch_assoc($admin)) {
			$createdBy=$row["username"];
		}
		
		do {
			if($addEdit=="add"){			
				$mySql = mysqli_query($connection, "SELECT AUTO_INCREMENT
				FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'comd_light_ci' 
				AND TABLE_NAME = 'devices'");
				
				$row = mysqli_fetch_array($mySql);
				if($mySql->num_rows < 1) {
					$result="1";
					break;
				}
				
				$newDeviceName = $deviceName.$row["AUTO_INCREMENT"];
				
				$sql = "INSERT INTO devices (device_name, device_detail, device_longitud, device_latitud, location_id, client_id, status, CreatedBy, CreatedDate, LatestUpdateDate, LastUpdateDate, device_height, device_activation, site_region, client_batch_number, sim_serial_number, sim_provider, battery_status, rssi_status) 
				VALUES ('".$newDeviceName."', '".$deviceDetail."','".$latitude."','".$longitude."','".$location."','".$client."','1','".$createdBy."','".$CreatedDate."','".$CreatedDate."','".$CreatedDate."','".$height."','".$activationDate."','".$siteRegion."','".$batchNum."','".$serialNum."','".$simProvider."','".$batteryStatus."','".$rssiStatus."')";
				
				if ($connection->query($sql) === TRUE) {
					$result = "0";
					//break;
					}else{
					$result = "-1";
					break;
				}
				}else if($addEdit=="edit"){
				$deviceExist = $connection->query("SELECT device_id FROM devices WHERE device_id = '".$id."'");
				if($deviceExist->num_rows < 1) {
					$result="3";
					break;
				}
				
				$sql = "UPDATE devices SET device_name = '".$deviceName."',device_detail = '".$deviceDetail."',device_longitud = '".$latitude."'
				,device_latitud = '".$longitude."',location_id = '".$location."',client_id = '".$client."',ModifiedBy = '".$createdBy."'
				,ModifiedDate = '".$CreatedDate."',device_height = '".$height."',device_activation = '".$activationDate."',site_region = '".$siteRegion."'
				,client_batch_number = '".$batchNum."',sim_serial_number = '".$serialNum."',sim_provider = '".$simProvider."',battery_status = '".$batteryStatus."'
				,rssi_status = '".$rssiStatus."' WHERE device_id = '".$id."'";
				
				if ($connection->query($sql) === TRUE) {
					$result="10";
					break;
				}
			}
			$quantity--;
		} while ($quantity>0&&$addEdit=="add");
		
		
		}else{
		$result = "2";
	}
	
	echo json_encode((string)$result);
	$connection->close();
?>
