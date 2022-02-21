<?php
header("Content-type: text/html");
$tgt=$_POST['name'];
$cmd='sudo /var/www/html/t-scan.sh ';
$comb=$cmd.$tgt;
passthru($comb);
// header('Location: http://www.google.com');
?>
