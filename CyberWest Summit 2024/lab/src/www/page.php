<?php
$file = $_GET['file'];
$www = "/var/www/html/";
$page = $www . $file;
if (file_exists($page)){
    include($page);
}
else {
    header("Location: /");
}
?>
