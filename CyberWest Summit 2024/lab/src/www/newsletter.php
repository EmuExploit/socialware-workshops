<?php

ini_set('display_errors', 0);

$user = "shane";
$pass = "dblover98";
$db = "securesales";
$mysqli = new mysqli("localhost", $user, $pass, $db);

if ($mysqli->connect_error) {
    header("HTTP/1.1 500 Internal Server Error");
    die("Connection failed: " . $mysqli->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    foreach ($_POST as $key => $value) {
            $query = "INSERT INTO newsletters (email, subscribed) VALUES ('$value', true);";
// attacker@evil.com', true); INSERT INTO users (username, email, password) VALUES ('attacker', 'attacker@evil.com', 'hacked'); -- -
if (!$mysqli->multi_query($query)) {
                    header("HTTP/1.1 500 Internal Server Error");
                    die("Error executing query: " . $mysqli->error . "\nQuery: " . $query);
        }
    }
    mysqli_close($conn);
    header('Location: /');
} else {
    header("HTTP/1.1 500 Internal Server Error");
    die("Invalid request method.");
}
$mysqli->close();

?>