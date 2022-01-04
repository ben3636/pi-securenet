### Calculate Subnet
subnet_part1=$(ip a | grep -o ".*\.*\.*\/.. " | grep -v inet6 | sed -e s/'inet'// -e s/" "// | awk -F '.' ' { print $1"."$2"."$3"." } ' | awk ' { print $1 } ')
subnet_part2="0"
mask=$(ip a | grep -o ".*\.*\.*\/.. " | grep -v inet6 | grep -o /..)
subnet=$subnet_part1$subnet_part2$mask

### Generate Baseline
nmap -sn -PR $subnet -T5 | awk '/Nmap scan report for/{printf $5;printf " "$6;}/MAC Address:/{print " => "$3, $4, $5, $6;}' | sed -e "s/  =>/ =>/g" > /var/www/html/scans/"discovery-baseline"
echo "--- Baseline Scan Results ---"
echo
cat /var/www/html/scans/"discovery-baseline" | while read line
do
        echo $line
        echo
        echo
done
