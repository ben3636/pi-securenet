#!/bin/bash

### Set Initial Counter Value
i=1

### Calculate Subnet
subnet_part1=$(ip a | grep -o ".*\.*\.*\/.. " | grep -v inet6 | sed -e s/'inet'// -e s/" "// | awk -F '.' ' { print $1"."$2"."$3"." } ' | awk ' { print $1 } ')
subnet_part2="0"
mask=$(ip a | grep -o ".*\.*\.*\/.. " | grep -v inet6 | grep -o /..)
subnet=$subnet_part1$subnet_part2$mask

### Create Scan Directory & Get Current Date
mkdir -p scans
date=$(date)

### Run Scan & Export to Report File
nmap -T5 $subnet --script=vuln -oN /var/www/html/scans/"vulnscan-$date" >> /dev/null

### Print first half of HTML before placeholder
cat Vulnerability-Scan.html.p1
echo -n '<p class="u-align-left u-text u-text-3">'

### Parse the results file and extract fields
cat scans/"vulnscan-$date" | grep -v "Status: Up"  | grep -v ^#  \
| sed '1,2d' | sed -e s/^$/'<br><br>'/g -e s/'|'/'<br>---------|'/g -e s/'Host is up.*\.'/'<br>'/g -e s/"Not shown:.*ports"//g -e s/'Not shown: .* filtered ports'//g -e s/'Not shown: .* closed ports'//g  -e s/"PORT.*STATE.*SERVICE"/'*'/g
echo '</p>'

### Print second half of the HTML after the placeholder
cat Vulnerability-Scan.html.p2
