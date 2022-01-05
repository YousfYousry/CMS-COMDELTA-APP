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
	
	$activeSince = date('Y-m-d H:i:s', ($now - 72 * 60 * 60));
	
	$sqlNot = mysqli_query($connection, "SELECT * FROM notification");
	
	while($rowPhone = mysqli_fetch_array($sqlNot)){
		
		$queryInActive = $connection-> query("SELECT * FROM devices WHERE client_id = ".$rowPhone["client_id"]." AND LatestUpdateDate < '".$activeSince."'");
		
		if($queryInActive->num_rows != $rowPhone["inactiveDevices"]){
			
			$sql = "UPDATE notification SET inactiveDevices =  '".$queryInActive->num_rows."'  WHERE token = '".$rowPhone["token"]."'";
			
			$connection->query($sql);
			
			define('API_ACCESS_KEY','AAAALxaxoTQ:APA91bE-GtwQasZP88Y_Lg6O5wAf7iqxoY7PcKlsgEACT8bAXnGwYqBOKPhEZUNqJseJ6TPtMVzu99E_KywvB81zDwNlQB4LrhqNRctqxc5dswKw2VgyAc7WLlGlmqtwYw-ptir_t1f9');
			
			$fcmUrl = 'https://fcm.googleapis.com/fcm/send';
			
			$token = $rowPhone["token"];
			$str=$queryInActive->num_rows." Inactive devices";
			
			
			$diff=$queryInActive->num_rows-$rowPhone["inactiveDevices"];
			
			if($diff>0){
				$str=$diff." new inactive devices has been detected";
				}else{
				$diff*=-1;
				$str=$diff." new devices has been activated";
			}
			
			
			$notification = [
			'title'=>'Inactive devices',
			'body'=>$str
			];
			
			$extraNotificationData = ["message" => $notification,"moredata" =>'dd'];
			
			$fcmNotification = [
			//'registration_ids' => $tokenList, //multple token array
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
?>
<script>
	setTimeout(function () { window.location.reload(); }, 6000);
	// just show current time stamp to see time of last refresh.
	document.write(new Date());
</script>		