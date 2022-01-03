<?php
$filename = 'scans/discovery-baseline';
$line = $_POST['entry'];
$line = "\n".$line." # Added Manually Via /whitelist.php\n";
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

    echo "Device "."<b><u>".$line."</u></b>"." has been added to the baseline file";
    fclose($fp);

} else {
    echo "The file $filename is not writable";
}
?>
