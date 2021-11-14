<?php
header("Content-type: text/html");
passthru('sudo /var/www/html/logins.sh');
// header('Location: http://www.google.com');
?>
