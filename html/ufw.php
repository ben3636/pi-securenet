<?php
header("Content-type: text/html");
passthru('sudo /var/www/html/ufw.sh');
// header('Location: http://www.google.com');
?>
