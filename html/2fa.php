<?php
header("Content-type: text/plain");
passthru('/var/www/html/auth/2fa.sh');
// header('Location: http://www.google.com');
?>
