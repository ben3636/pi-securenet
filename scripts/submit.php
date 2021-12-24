<?php
$filename = 'alias.txt';
$mac = $_POST['mac'];
$alias = $_POST['alias'];
$line = $mac." --> ".$alias."\n";
// Let's make sure the file exists and is writable first.
if (is_writable($filename)) {
    if (!$fp = fopen($filename, 'a')) {
         echo "Cannot open file ($filename)";
         exit;
    }

    if (fwrite($fp, $line) === FALSE) {
        echo "Cannot write to file ($filename)";
        exit;
    }

    echo "Device ("."<b><u>".$mac."</u></b>".") is now known as ("."<b><u>".$alias."</u></b>".")";
    fclose($fp);

} else {
    echo "The file $filename is not writable";
}
?>
