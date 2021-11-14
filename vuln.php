<?php
header("Content-type: text/html");
passthru('sudo /var/www/html/vuln.sh');
// header('Location: http://www.google.com');
?>
