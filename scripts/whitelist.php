<h1>Whitelist Device // Add Device to "Baseline"</h1>
<br>
<h3><u>Most Recent Differential Scan Results</u></h3>
<?php
header("Content-type: text/html");
passthru('cat /var/www/html/scans/discovery-differential | while read line; do echo $line; echo "<br>"; echo "<br>"; done');
?>
<form action="whitelist_submit.php" method="post">
 <p>Entry to Suppress (Copy an entire line from above): <input type="text" name="entry" /></p>
 <p><input type="submit" /></p>
</form>
