#!/bin/bash

### Set initial counter value
i=1

### Define Functions
function table(){
        echo '<tr style="height: 66px;">'
		echo '	<td class="u-border-1 u-border-palette-5-dark-1 u-table-cell u-table-cell-'$i\"'>'$1'</td>'
		((i+=1))
                echo '  <td class="u-border-1 u-border-palette-5-dark-1 u-table-cell u-table-cell-'$i\"'>'$2'</td>'
                ((i+=1))
	echo '</tr>'
}

### Create Scan Folder && Get Current Date
mkdir -p scans
date=$(date)

### Run Scan & Export to Report File
nmap -sn -PR 192.168.10.0/24 -T5 -oG /var/www/html/scans/"scan-$date" >> /dev/null

### Print first half of the HTML before the table
cat Discovery-Scan.html.p1

### Parse the scan file and extract fields
cat scans/"scan-$date" | grep -v ^# | sed '1,3d' \
| while read line
do
	ip=$(echo $line | awk ' { print $2 } ')
        hostname=$(echo $line | awk ' { print $3 } ')
	if [[ $hostname == "()" ]] || [[ $hostname == '' ]]
	then
		hostname='N/A'
	fi
	table $ip $hostname
done

### Print second half of the HTML after the table
cat Discovery-Scan.html.p2
