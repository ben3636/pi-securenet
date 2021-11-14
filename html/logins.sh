#!/bin/bash

### Set Initial Counter Value
i=1

### Get Current Date
date=$(date | awk ' { print $2,$3 } ')

### Print the first half of the HTML up to the table items
cat Login-Activity.html.p1

### Define Functions
function section(){
	for i in range {1..3}
	do
		echo '  <td class="u-border-1 u-border-palette-5-dark-1 u-table-cell u-table-cell-'$i\"'>'--------------------------'</td>'
		((i+=1))
	done
}

function table(){
        echo '<tr style="height: 66px;">'
		echo '	<td class="u-border-1 u-border-palette-5-dark-1 u-table-cell u-table-cell-'$i\"'>'$1'</td>'
		((i+=1))
                echo '  <td class="u-border-1 u-border-palette-5-dark-1 u-table-cell u-table-cell-'$i\"'>'$2'</td>'
                ((i+=1))
                echo '  <td class="u-border-1 u-border-palette-5-dark-1 u-table-cell u-table-cell-'$i\"'>'$3'</td>'
                ((i+=1))
                echo '  <td class="u-border-1 u-border-palette-5-dark-1 u-table-cell u-table-cell-'$i\"'>'$4'</td>'
                ((i+=1))
	echo '</tr>'
}

### Print Successful Logon Table Divider
#section "SUCCESSFUL"

### Get Successful Authentication Events from Today & Parse Fields
cat /var/log/auth.log | grep "$date" | grep -o "^.*session opened.*$" | grep -e "login" -e "sshd" |\
while read line
do
	action="SUCCESS"
	type=$(echo $line | awk ' { print $5  } ' | sed -e s/"\[.*\]"//g)
        user=$(echo $line | awk ' { print $11  } ' | sed -e s/\'//g -e s/','//g)
	datetime=$(echo $line | awk ' { print $1,$2,$3 } ')
	if [[ $type == "sshd:" ]]
	then
		type="SSH"
	fi
	if [[ $type == "login:" ]]
	then
		type="TTY"
	fi
	table "$action" "$datetime" "$type" "$user"

done

### Print Failed Logon Table Divider
section "FAILED"

### Get Last 10 Failed Authentication Events & Parse Fields
cat /var/log/auth.log | grep -i -e "failed login" -i -e "failed password" | tail -n 10 |\
while read line
do
	## Determine if which type of failed event this is and parse accordingly
	if [[ $line == *"FAILED LOGIN"* ]]
	then
		action="FAILED"
	        type=$(echo $line | awk ' { print $5  } ' | sed -e s/"\[.*\]"//g)
	        if [[ $type == "sshd:" ]]
       		 then
                	type="SSH"
        	fi
        	if [[ $type == "login:" ]]
       		then
               		 type="TTY"
       		fi
		user=$(echo $line | awk ' { print $12 } ' | sed -e s/\'//g -e s/','//g)
		datetime=$(echo $line | awk ' { print $1,$2,$3 } ')

	        ## Pass fields to table function to create HTML table
	        table "$action" "$datetime" "$type" "$user"

	elif [[ $line = *"Failed password"* ]]
	then
		action="FAILED"
                type=$(echo $line | awk ' { print $5  } ' | sed -e s/"\[.*\]"//g)
                if [[ $type == "sshd:" ]]
                then
                        type="SSH"
                fi
                if [[ $type == "login:" ]]
                then
                         type="TTY"
                fi
                user=$(echo $line | awk ' { print $9 } ' | sed -e s/\'//g -e s/','//g)
		datetime=$(echo $line | awk ' { print $1,$2,$3 } ')

                ## Pass fields to table function to create HTML table
	        table "$action" "$datetime" "$type" "$user"
	fi
done

## Print second half of the HTML after the table
Login-Activity.html.p2
