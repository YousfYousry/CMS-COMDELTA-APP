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
	
	$title = $_POST["title"];
	// $title = "title";
	$description = $_POST["description"];
	// $description = "description";
	
	$sqlNot = mysqli_query($connection, "SELECT token FROM phones WHERE user_type = '2' OR user_type = '1'");
	
	define('API_ACCESS_KEY','AAAALxaxoTQ:APA91bE-GtwQasZP88Y_Lg6O5wAf7iqxoY7PcKlsgEACT8bAXnGwYqBOKPhEZUNqJseJ6TPtMVzu99E_KywvB81zDwNlQB4LrhqNRctqxc5dswKw2VgyAc7WLlGlmqtwYw-ptir_t1f9');
	$fcmUrl = 'https://fcm.googleapis.com/fcm/send';
	
	
	while($rowPhone = mysqli_fetch_array($sqlNot)){
		$token = $rowPhone["token"];
		// $token = "f_LrWTxQTOyNHNJ4MVseRX:APA91bEqr_Mx4G2kf5qxDQwIA3oE8JWy5Q-LBWimATQCqDDB5aVOsrDAXkEGcXQ5MRMMo6JCK6HJgRJGC3bw6iwdUyxx_5Lz2rlOlTflYDyx94u_uKOHL0PJ4E6Tj5dkkNahdr133izf";
		
		$notification = [
		'title'=>$title,
		'body'=>$description
		];
		
		$extraNotificationData = ["message" => $notification,"moredata" =>'dd'];
		
		$fcmNotification = [
		'to'        =>$token,
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
	$connection -> close();
?>