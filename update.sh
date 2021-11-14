#!/bin/bash

function split_table(){
	sed '/<tbody class="u-black u-table-body u-table-body-1">/q' "$1" > "$1.p1"
	sed -n '/<\/tbody>/,$p' "$1" > "$1.p2"

}

function split(){
	sed '/SCANRESULTS/q' "$1" | sed s/SCANRESULTS....$// > "$1.p1"
	sed -n '/SCANRESULTS/,$p' "$1" | sed s/^.*SCANRESULTS// > "$1.p2"

}

function load(){
	for i in range {1..5}
	do
		echo "."
		echo
		sleep .02
	done
}

clear
if [[ $1 == "" ]]
then
	echo "Please Specify a full HTML Page to split..."
	load
	ls -1 /var/www/html | grep html$
	exit 1
fi


if [[ ! -f "$1" ]]
then
        echo "Error: File not found"
	load
	exit 1
else
	echo "File exists!"
fi

if [[ $1 != *"Vulnerability-Scan.html"* ]]
then
	split_table $1
else
	split $1
fi
load
echo "HTML File Successfully Split & Updated..."
load
