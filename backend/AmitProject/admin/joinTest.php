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
	$activeSince = date('Y-m-d H:i:s', ($now - 72 * 60 * 60));
	
	
	// echo difference($now , strtotime($activeSince));
	// echo date('Y-m-d H:i:s', (strtotime($activeSince) + 72 * 60 * 60));
	
	// function difference(int $a, int $b) {
	
	// $diff = abs($a-$b);
	// $years=0;
	// $months=0;
	// $days=0;
	// $hours=0;
	// while(floor($diff/3600)>0){
	// if($diff>=31536000){
	// $diff-=31536000;
	// $years++;
	// }else if($diff>=2592000){
	// $diff-=2592000;
	// $months++;
	// }else if($diff>=86400){
	// $diff-=86400;
	// $days++;
	// }else if($diff>=3600){
	// $diff-=3600;
	// $hours++;
	// }
	
	// }
	
	// $years = floor($diff / (365*60*60*24));
	// $months = floor(($diff - $years * 365*60*60*24) / (30*60*60*24));
	// $days = floor(($diff - $years * 365*60*60*24 - $months*30*60*60*24)/ (60*60*24));
	
	// return years." years, ".$months." months, ".$days." days, ".$hours." hours";
	// }
	
	//update history recorder table
	// $connection-> query("INSERT INTO devicehistory (device_id, change_date, inactive_period, active) SELECT devices.device_id, '".date('Y-m-d H:i:s', $now)."', '0' ,'0' FROM devices WHERE devices.LatestUpdateDate < '".$activeSince."' AND devices.status_recorder = '1'");
	// $insertedInactive= $connection -> affected_rows;
	// $connection-> query("INSERT INTO devicehistory (device_id, change_date, inactive_period, active) SELECT devices.device_id, '".date('Y-m-d H:i:s', $now)."', TIMESTAMPDIFF(SECOND,devices.last_active_date, current_timestamp()), '1' FROM devices WHERE devices.LatestUpdateDate >= '".$activeSince."' AND devices.status_recorder = '0'");
	// $insertedActive= $connection -> affected_rows;
	
	// if($insertedInactive>0||$insertedActive>0){
	// //update devices table
	// $connection-> query("UPDATE devices SET status_recorder = '0' WHERE LatestUpdateDate < '".$activeSince."'");
	// $inactiveNum= $connection -> affected_rows;
	// $connection-> query("UPDATE devices SET status_recorder = '1', last_active_date = LatestUpdateDate WHERE LatestUpdateDate >= '".$activeSince."'");
	// $activeNum= $connection -> affected_rows;
	
	define('API_ACCESS_KEY','AAAALxaxoTQ:APA91bE-GtwQasZP88Y_Lg6O5wAf7iqxoY7PcKlsgEACT8bAXnGwYqBOKPhEZUNqJseJ6TPtMVzu99E_KywvB81zDwNlQB4LrhqNRctqxc5dswKw2VgyAc7WLlGlmqtwYw-ptir_t1f9');
	$fcmUrl = 'https://fcm.googleapis.com/fcm/send';
	
	
	// if($inactiveNum>0||$activeNum >0){
	
	
	// $str="";
	
	// if($inactiveNum>0){
	// $str.= "New inactive: " .$inactiveNum;
	// }
	
	// if($activeNum >0){
	// if($inactiveNum>0){
	// $str.= ",  ";
	// }
	// $str.= "New active: " .$activeNum;
	// }
	
	$token = "fawc4ZiZRHONaw8CrnUupy:APA91bE5fLpf6_Ol_nbpuijI6-I6sJe205ztewZasmgJTA-t8Bg5s-o5Om6Ft6qrOcTfSubAm4L4HqfqLosTnM-d0wPZ4k7N-PbCXYG4DWhy2UJ0uWAIhoCFLP60LTad_OPhj2Sf0maB";
	
	$notification = [
	'title'=>'Test',
	'body'=>"Please inform me when you recieve this"
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
	// }
	// }
	$connection -> close();
?>