#!/bin/bash

### Set Initial Counter Value
i=1

### Create Scan Directory & Get Current Date
mkdir -p scans
date=$(date)

### Run Scan & Export to Report File
#nmap -T5 192.168.10.0/24 --script=vuln -oN /var/www/html/scans/"vulnscan-$date" >> /dev/null

### Print first half of HTML before placeholder
cat Vulnerability-Scan.html.p1
echo -n '<p class="u-align-left u-text u-text-3">'

### Parse the results file and extract fields
#cat scans/"vulnscan-$date" | grep -v "Status: Up"  | grep -v ^#  \
cat scans/vulntest | sed '1,2d' | sed -e s/^$/'<br><br>'/g -e s/'|'/'<br>---------|'/g -e s/'Host is up.*\.'/'<br>'/g -e s/"Not shown:.*ports"//g -e s/'Not shown: .* filtered ports'//g -e s/'Not shown: .* closed ports'//g  -e s/"PORT.*STATE.*SERVICE"/'*'/g
echo '</p>'

### Print second half of the HTML after the placeholder
cat Vulnerability-Scan.html.p2
