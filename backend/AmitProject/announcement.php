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
		
	$sqlNot = mysqli_query($connection, "SELECT * FROM notification");
	
	while($rowPhone = mysqli_fetch_array($sqlNot)){
		
								
			define('API_ACCESS_KEY','AAAALxaxoTQ:APA91bE-GtwQasZP88Y_Lg6O5wAf7iqxoY7PcKlsgEACT8bAXnGwYqBOKPhEZUNqJseJ6TPtMVzu99E_KywvB81zDwNlQB4LrhqNRctqxc5dswKw2VgyAc7WLlGlmqtwYw-ptir_t1f9');
			
			$fcmUrl = 'https://fcm.googleapis.com/fcm/send';
			
			$token = $rowPhone["token"];
			
			
			$notification = [
			'title'=>'New update',
			'body'=>'The server will check devices and send notification one time every 10 minutes instead of 1 minute'
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
?>