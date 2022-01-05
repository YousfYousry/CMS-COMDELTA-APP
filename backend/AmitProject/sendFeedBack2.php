<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'PHPMailer/Exception.php';
require 'PHPMailer/PHPMailer.php';
require 'PHPMailer/SMTP.php';

$mail = new PHPMailer(true); //Argument true in constructor enables exceptions

//From email address and name
$mail->From = "yousfzaghlol@gmail.com";
$mail->FromName = "yousfzaghlol";

//To address and name
$mail->addAddress("yousefzaghloul17@gmail.com", "yousf");
$mail->addAddress("yousefzaghloul17@gmail.com"); //Recipient name is optional

//Address to which recipient will reply
$mail->addReplyTo("yousfzaghlol@gmail.com", "Reply");

//CC and BCC
$mail->addCC("yousefzaghloul17@gmail.com");
$mail->addBCC("yousefzaghloul17@gmail.com");

//Send HTML or Plain Text email
$mail->isHTML(true);

$mail->Subject = "Subject Text";
$mail->Body = "<i>Mail body in HTML</i>";
$mail->AltBody = "This is the plain text version of the email content";

try {
    $mail->send();
    echo "Message has been sent successfully";
} catch (Exception $e) {
    echo "Mailer Error: " . $mail->ErrorInfo;
}
?>