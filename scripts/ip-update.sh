ip=$(ip -p address | grep "^    inet " | grep -v "127.0.0" | awk ' { print $2 } ' | sed -e s/"\/.."//g)
echo "-$ip-"
sed -e s/"192.168.10.4"/"$ip"/g /var/www/html/*.html
ls -1 /var/www/html/ | grep .html | while read line
do
        ~/pi-securenet/update.sh /var/www/html/"$line"
done
