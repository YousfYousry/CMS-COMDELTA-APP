<?php
    $servername = "localhost:3307";
    $username = "root";
    $password = "eWw8yk36Lh6977su";
    $dbname = "comd_light_ci_v2";

    $connection = new mysqli($servername, $username, $password, $dbname);
      if($connection ->connect_error){
        die("Connection Failed: " . $conn->connect_error);
        return;
    }
 header('Content-Type: application/json');

$queryResult = $connection-> query("SELECT * FROM devices");

  $result = array();

  while ($fetchdata=$queryResult->fetch_assoc()) {
      $result[] = $fetchdata;
  }

  echo json_encode($result);
?>
