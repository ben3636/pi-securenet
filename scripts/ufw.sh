#!/bin/bash

### Set Initial Counter Value
i=1

### Define Functions
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

### Print first half of the HTML before the table
cat UFW.html.p1

### Parse the list of rules and extract fields
ufw status | grep -v '(v6)' | sed '1,4d' | sed '/^$/d' | sort -k4 \
| while read line
do
	# Determine if rule is inbound or outbound and parse accordingly
	f1=$(echo $line | awk ' { print $3 } ')
        f2=$(echo $line | awk ' { print $4 } ')
	if [[ $f1 == "OUT" ]] || [[ $f2 == "OUT" ]]
	then
		port_and_dest=$(echo $line | grep OUT | grep -oe ^.*ALLOW -oe ^.*DENY | sed -e s/DENY//g -e s/ALLOW//g)
		proto=$(echo $line | grep -oe tcp -oe udp)
		if [[ $proto == '' ]]
		then
			proto="ANY"
		fi
		action=$(echo $line | grep -oe ALLOW -oe DENY)
		source=$(echo $line | awk ' { print $NF} ')
		port_and_dest="Pi --> $port_and_dest (Out)"

                # Pass fields to table function for HTML formatting
                table "$port_and_dest" "$proto" "$action" "$source"
	else
		# Determine if rule is by port or service and parse accordingly
		if [[ $line != *"tcp"* && $line != *"udp"* ]]
		then
			port=$(echo $line | awk ' { print $1 } ')
			port="Pi <-- $port (In)"
	                action=$(echo $line | awk ' { print $2 } ')
	                proto='N/A'
	                source=$(echo $line | awk ' { print $3 } ')

			# Pass fields to table function for HTML formatting
  	              table "$port" "$proto" "$action" "$source"
		else
			port=$(echo $line | awk ' { print $1 } '| awk -F '/' ' { print $1 } ')
                        port="Pi <-- $port (In)"
	        	proto=$(echo $line | awk ' { print $1 } '| awk -F '/' ' { print $2 } ')
			action=$(echo $line | awk ' { print $2 } ')
	        	source=$(echo $line | awk ' { print $3 } ')

	                # Pass fields to table function for HTML formatting
			table "$port" "$proto" "$action" "$source"
		fi
	fi
done

### Print second half of the HTML after the table
cat UFW.html.p2
