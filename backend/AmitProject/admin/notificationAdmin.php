<?php
	// sleep(3);
	
	
    $servername = "localhost:3307";
    $username = "root";
    $password = "eWw8yk36Lh6977su";
    $dbname = "comd_light_ci";
	// include 'timeVar.php';
	$now = time();
	
    $connection = new mysqli($servername, $username, $password, $dbname);
	if($connection ->connect_error){
        die("Connection Failed: " . $connection->connect_error);
        return;
	}
	$activeSince = date('Y-m-d H:i:s', ($now - 72 * 60 * 60));
	
	//update history recorder table
	$connection-> query("INSERT INTO devicehistory (device_id, change_date, inactive_period, active) SELECT devices.device_id, '".date('Y-m-d H:i:s', $now)."', '0' ,'0' FROM devices WHERE devices.LatestUpdateDate < '".$activeSince."' AND devices.status_recorder = '1'");
	$insertedInactive= $connection -> affected_rows;
	$connection-> query("INSERT INTO devicehistory (device_id, change_date, inactive_period, active) SELECT devices.device_id, '".date('Y-m-d H:i:s', $now)."', TIMESTAMPDIFF(SECOND,devices.last_active_date, current_timestamp()), '1' FROM devices WHERE devices.LatestUpdateDate >= '".$activeSince."' AND devices.status_recorder = '0'");
	$insertedActive= $connection -> affected_rows;
	
	if($insertedInactive>0||$insertedActive >0){
		
		//update devices table
		$connection-> query("UPDATE devices SET status_recorder = '0', last_active_date = LatestUpdateDate WHERE LatestUpdateDate < '".$activeSince."'");
		$inactiveNum= $connection -> affected_rows;
		$connection-> query("UPDATE devices SET status_recorder = '1', last_active_date = LatestUpdateDate WHERE LatestUpdateDate >= '".$activeSince."'");
		$activeNum= $connection -> affected_rows;
		
		// $queryInActive = $connection-> query("SELECT * FROM devices WHERE LatestUpdateDate < '".$activeSince."'");
		$sqlNot = mysqli_query($connection, "SELECT token FROM phones WHERE user_type != '3'");
		
		
		// $holder = array();
		// while($row = mysqli_fetch_array($sqlNot)) {
		// $holder[] = $row["token"]; 
		// }
		// $notList = array($holder);
		
		define('API_ACCESS_KEY','AAAALxaxoTQ:APA91bE-GtwQasZP88Y_Lg6O5wAf7iqxoY7PcKlsgEACT8bAXnGwYqBOKPhEZUNqJseJ6TPtMVzu99E_KywvB81zDwNlQB4LrhqNRctqxc5dswKw2VgyAc7WLlGlmqtwYw-ptir_t1f9');
		$fcmUrl = 'https://fcm.googleapis.com/fcm/send';
		
		
		while($rowPhone = mysqli_fetch_array($sqlNot)){
			
			// if($queryInActive->num_rows != $rowPhone["inactiveDevices"]){
			
			// $sql = "UPDATE notification SET inactiveDevices = '".$queryInActive->num_rows."'  WHERE token = '".$rowPhone["token"]."'";
			
			// $connection->query($sql);
			
			$str="";
			
			if($insertedInactive>0){
				$str.= "New inactive: " .$insertedInactive;
			}
			
			if($insertedActive >0){
				if($insertedInactive>0){
					$str.= ",  ";
				}
				$str.= "New active: " .$insertedActive;
			}
			
			$token = $rowPhone["token"];
			
			
			// $diff=$queryInActive->num_rows-$rowPhone["inactiveDevices"];
			
			// if($diff>0){
			// $str=$diff." new inactive devices has been detected";
			// }else{
			// $diff*=-1;
			// $str=$diff." new devices has been activated";
			// }
			
			
			$notification = [
			'title'=>'Device Status',
			'body'=>$str
			];
			
			$extraNotificationData = ["message" => $notification,"moredata" =>'dd'];
			
			$fcmNotification = [
			// 'registration_ids' => $notList, //multple token array
			'to'        =>$token, //single token
			'notification' => $notification,
			'data' => $extraNotificationData
			];
			
			$headers = [
			'Authorization: key=' . API_ACCESS_KEY,
			'Content-Type: application/json'
			];
			
			
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_URL,$fcmUrl);
			curl_setopt($ch, CURLOPT_POST, true);
			curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
			curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fcmNotification));
			$result = curl_exec($ch);
			curl_close($ch);
			
			
			echo $result;
		}
	}
	$connection -> close();
?>	