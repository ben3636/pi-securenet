#!/bin/bash

### Set initial counter value
i=1

### Calculate Subnet
subnet_part1=$(ip a | grep -o ".*\.*\.*\/.. " | grep -v inet6 | sed -e s/'inet'// -e s/" "// | awk -F '.' ' { print $1"."$2"."$3"." } ' | awk ' { print $1 } ')
subnet_part2="0"
mask=$(ip a | grep -o ".*\.*\.*\/.. " | grep -v inet6 | grep -o /..)
subnet=$subnet_part1$subnet_part2$mask

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
nmap -sn -PR $subnet -T5 | awk '/Nmap scan report for/{printf $5;printf " "$6;}/MAC Address:/{print " => "$3, $4, $5, $6;}' > /var/www/html/scans/"scan-$date"

### Print first half of the HTML before the table
cat Discovery-Scan.html.p1

### Parse the scan file and extract fields
cat scans/"scan-$date" | grep -v ^# \
| while read line
do
        mac=$(echo $line | awk -F ' => ' ' { print $2 } ')

	# Determine if initial scan found hostname and parse accordingly
        if [[ $(echo $line | awk -F ' => ' ' { print $1 } ' | wc -l) != 1 ]]
        then
                host=$(echo $line | awk -F ' => ' ' { print $1 } ' | awk ' { print $2 } ' | sed -e "s/(//g" -e "s/)//g")
                hostname=$(echo $line | awk -F ' => ' ' { print $1 } ' | awk ' { print $1 } ')
        elif [[ $(echo $line | awk -F ' => ' ' { print $1 } ' | wc -l) == 1 ]]
        then
                hostname=''
                host=$(echo $line | awk -F ' => ' ' { print $1 } ' | awk ' { print $1 } ' | sed -e "s/(//g" -e "s/)//g")
        fi

        # Perform Hostname Lookup If Needed
        if [[ $hostname == '' ]]
        then
                # Attempt to determine multicast/avahi/mdns hostname if no DNS name
                #echo "Performing Hostname Discovery...($host)"
                hostname=$(avahi-browse -ratp | grep $host | awk -F ";" ' { print $7 } ' | uniq)
                if [[ $hostname == "()" ]] || [[ $hostname == '' ]]
                then
                        hostname='N/A'
                fi
        fi

        # Perform MAC Vendor Lookup If Needed
        if [[ $mac == '' ]]
        then
                #echo "Performing MAC Vendor Lookup...($host)"
                mac=$(nmap -sn -PR -T5 $host | grep "^MAC" | sed s/"MAC Address: "//g)
        fi

	# Combine MAC and Hostname Depending on Enrichment Results
        if [[ $hostname == 'N/A' ]] && [[ $mac != '' ]]
        then
                hostname="$mac"
        elif [[ $hostname != "N/A" ]] && [[ $mac != '' ]]
        then
                hostname="$hostname -- $mac"
        fi

	# Check for Custom Aliases for Device
	mac_address=$(echo $mac | awk ' { print $1 } ')
	ip=$host
	if [[ $mac_address != '' ]]
	then
		alias=$(cat /var/www/html/alias.txt | grep "$mac_address" | awk -F " --> " ' { print $2 } ')
		if [[ $alias != '' ]]
		then
			#echo "Alias for $mac_address found!: $alias"
			if [[ $alias != '' ]] && [[ $mac != '' ]]
			then
				hostname="$alias -- $mac"
			elif [[ $alias != '' ]] && [[ $mac == '' ]]
			then
				hostname="$alias"
			fi
		fi
	fi
	table "$ip" "$hostname"
done

### Print second half of the HTML after the table
cat Discovery-Scan.html.p2
