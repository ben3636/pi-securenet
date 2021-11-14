<?php
header("Content-type: text/html");
passthru('sudo /var/www/html/discovery.sh');
// header('Location: http://www.google.com');
?>
