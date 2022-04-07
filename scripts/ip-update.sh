ip=$(ip -p address | grep "^    inet " | grep -v "127.0.0" | awk ' { print $2 } ' | sed -e s/"\/.."//g)
rm /var/www/html/*.p1
rm /var/www/html/*.p2
echo "-- $ip --"
sleep 5
sed -i -e s/"192.168.10.4"/"$ip"/g /var/www/html/*.html
sed -i -e s/"192.168.10.4"/"$ip"/g /var/www/html/*.php
ls -1 /var/www/html/ | grep .html | while read line
do
        ~/pi-securenet/update.sh /var/www/html/"$line"
done
