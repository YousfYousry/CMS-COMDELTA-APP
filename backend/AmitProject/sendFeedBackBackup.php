<?php
	/**
		* This example shows how to send via Google's Gmail servers using XOAUTH2 authentication.
	*/
	//$connection = new mysqli('localhost:3307', 'root', 'eWw8yk36Lh6977su', 'comd_light_ci');
	//if($connection ->connect_error){
	//	die("Connection Failed: " . $connection->connect_error);
	//	return;
	//}
	
	//$sql = mysqli_query($connection, "SELECT users.first_name,users.last_name from users WHERE user_id = '".$userId."'");
	//$row = mysqli_fetch_array($sql);
	
	//$From = $row["first_name"].' '.$row["last_name"];
	
	// $From = $_POST["from"];
	// $To = $_POST["to"];
	// $subject = $_POST["subject"];
	// $message = $_POST["message"];
	
	$From = 'test';
	$To = 'yousfzaghlol@gmail.com';
	$subject = 'subject';
	$message = 'message';
	
	//Import PHPMailer classes into the global namespace
	use PHPMailer\PHPMailer\PHPMailer;
	use PHPMailer\PHPMailer\SMTP;
	use PHPMailer\PHPMailer\OAuth;
	//Alias the League Google OAuth2 provider class
	use League\OAuth2\Client\Provider\Google;
	
	//SMTP needs accurate times, and the PHP time zone MUST be set
	//This should be done in your php.ini, but this is how to do it if you don't have access to that
	date_default_timezone_set('Etc/UTC');
	
	//Load dependencies from composer
	//If this causes an error, run 'composer install'
	require 'vendor/autoload.php';
	
	//Create a new PHPMailer instance
	$mail = new PHPMailer();
	
	//Tell PHPMailer to use SMTP
	$mail->isSMTP();
	
	//Enable SMTP debugging
	//SMTP::DEBUG_OFF = off (for production use)
	//SMTP::DEBUG_CLIENT = client messages
	//SMTP::DEBUG_SERVER = client and server messages
	$mail->SMTPDebug = SMTP::DEBUG_SERVER;
	
	//Set the hostname of the mail server
	$mail->Host = 'smtp.gmail.com';
	
	//Set the SMTP port number - 587 for authenticated TLS, a.k.a. RFC4409 SMTP submission
	$mail->Port = 587;
	
	//Set the encryption mechanism to use - STARTTLS or SMTPS
	$mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
	
	//Whether to use SMTP authentication
	$mail->SMTPAuth = true;
	
	//Set AuthType to use XOAUTH2
	$mail->AuthType = 'XOAUTH2';
	
	//Fill in authentication details here
	//Either the gmail account owner, or the user that gave consent
	$email = 'comdelta.feedback@gmail.com';
	$clientId = '202244202804-p9ep0m9abe4vfp5sfkvdgs547is1vo8o.apps.googleusercontent.com';
	$clientSecret = '4gTeKOmTRkz5X19PgSckw1vt';
	
	//Obtained by configuring and running get_oauth_token.php
	//after setting up an app in Google Developer Console.
	$refreshToken = '1//0geviU1g7J651CgYIARAAGBASNwF-L9IruKms_iRbEU7jRmdQcaIvsyumW7-rfRSxCCAeDg2uCUeGP2JGKFPRf1O8gwa7ITQVMtM';
	
	//Create a new OAuth2 provider instance
	$provider = new Google(
	[
	'clientId' => $clientId,
	'clientSecret' => $clientSecret,
	]
	);
	
	//Pass the OAuth provider instance to PHPMailer
	$mail->setOAuth(
	new OAuth(
	[
	'provider' => $provider,
	'clientId' => $clientId,
	'clientSecret' => $clientSecret,
	'refreshToken' => $refreshToken,
	'userName' => $email,
	]
	)
	);
	
	//Set who the message is to be sent from
	//For gmail, this generally needs to be the same as the user you logged in as
	$mail->setFrom($email, $From);
	
	//Set who the message is to be sent to
	$mail->addAddress($To, 'Comdelta');
	
	//Set the subject line
	$mail->Subject = $subject;
	
	//Read an HTML message body from an external file, convert referenced images to embedded,
	//convert HTML into a basic plain-text alternative body
	//$mail->CharSet = PHPMailer::CHARSET_UTF8;
	//$mail->msgHTML(file_get_contents('contentsutf8.html'), __DIR__);
	
	//Replace the plain text body with one created manually
	$mail->Body = $message;
	
	//Attach an image file
	//$mail->addAttachment('images/phpmailer_mini.png');
	
	//send the message, check for errors
	if (!$mail->send()) {
		echo 'Mailer Error: ' . $mail->ErrorInfo;
		} else {
		echo 'Message sent!';
	}
?>