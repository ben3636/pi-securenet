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
                echo '  <td class="u-border-1 u-border-palette-5-dark-1 u-table-cell u-table-cell-'$i\"'>'$3'</td>'
                ((i+=1))
	echo '</tr>'
}

### Create Scan Directory & Get Current Date
mkdir -p scans
date=$(date)

### Run Scan & Export to Report File
nmap -PR -T5 $subnet -p-1000 -oG /var/www/html/scans/"fullscan-$date" >> /dev/null

### Print first half of the HTML before the table
cat Full-Scan.html.p1

### Parse the results and extract fields
cat scans/"fullscan-$date" | grep -v "Status: Up"  | grep -v ^#  \
| while read line
do
	ip=$(echo $line | awk ' { print $2 } ')
        hostname=$(echo $line | awk ' { print $3 } ')
	results=$(echo $line | grep -o Ports.*|sed -e s/"\/\/\/"/'<br>'/g -e s/"Ports: "//g -e s/","//g -e s/"Ignored State:.*$"//g -e s/'\/'/' '/g \
	-e s/" open"/" - open"/g -e s/" filtered"/" - filtered"/g -e s/" closed"/" - closed"/g)
	mac=''
	if [[ $hostname == "()" ]]
	then
		hostname=''
	fi

        # Perform MAC Vendor Lookup
        if [[ $mac == '' ]]
        then
                #echo "Performing MAC Vendor Lookup...($ip)"
                mac=$(nmap -sn -PR -T5 $ip | grep "^MAC" | sed s/"MAC Address: "//g)
        fi

        # Check for Custom Aliases for Device
        mac_address=$(echo $mac | awk ' { print $1 } ')
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

        # Perform Hostname Lookup If Needed
        if [[ $hostname == '' ]]
        then
                # Attempt to determine multicast/avahi/mdns hostname if no DNS name
                #echo "Performing Hostname Discovery...($ip)"
                hostname=$(avahi-browse -ratp | grep $ip | awk -F ";" ' { print $7 } ' | uniq)
                if [[ $hostname != '' ]] && [[ $mac != '' ]]
                then
			hostname="$hostname -- $mac"
                elif [[ $hostname != '' ]] && [[ $mac == '' ]]
                then
                	hostname="$hostname"
		elif [[ $hostname == '' ]]
                then
                        hostname='N/A'
                fi
        fi

	# Combine MAC and Hostname Depending on Enrichment Results
        if [[ $hostname == 'N/A' ]] && [[ $mac != '' ]]
        then
                hostname="$mac"
        elif [[ $hostname != "N/A" ]] && [[ $mac != '' ]] && [[ $alias == '' ]]
        then
                hostname="$hostname -- $mac"
        fi

	# Pass fields to table function for HTML formatting
	table $ip "$hostname" "$results"
done

### Print second half of HTML after the table
cat Full-Scan.html.p2
