#!/bin/bash

timedatectl set-timezone America/New_York

# Ensure script is run by root
clear
if [[ $(whoami) != "root" ]]
then
  echo "Error: This script must be run as root!"
  exit 1
fi

# Enable & Configure Firewall
echo "Answer 'y' to enable firewall when prompted..."
sleep 5
ufw allow 22/tcp
ufw allow 80/tcp
ufw enable

# Fix Pi Zero Ubuntu Bug
apt install lz4
sed -i -e '/^COMPRESS=/ c COMPRESS=lz4' /etc/initramfs-tools/initramfs.conf

# Update
apt update && apt upgrade -y
apt autoremove -y

# Install Packages
apt install apache2 apache2-utils php nmap avahi-utils -y

# Migrate Files to Web Directory
rm /var/www/html/index.html
mv ~/pi-securenet/html/* /var/www/html/
mv ~/pi-securenet/scripts/* /var/www/html/
chmod +x /var/www/html/*.sh
touch /var/www/html/alias.txt
chmod o+w /var/www/html/alias.txt
mkdir -p /var/www/html/scans
touch /var/www/html/scans/discovery-differential
touch /var/www/html/scans/discovery-baseline
chmod o+w /var/www/html/scans/discovery-differential
chmod o+w /var/www/html/scans/discovery-baseline

# Split HTML Page Files from Templates
chmod +x ~/pi-securenet/update.sh
chmod +x /var/www/html/ip-update.sh
/var/www/html/ip-update.sh

# Add Sudo Privs for Web User
echo 'www-data ALL=(root) NOPASSWD:/var/www/html/discovery.sh' >> /etc/sudoers
echo 'www-data ALL=(root) NOPASSWD:/var/www/html/full.sh' >> /etc/sudoers
echo 'www-data ALL=(root) NOPASSWD:/var/www/html/logins.sh' >> /etc/sudoers
echo 'www-data ALL=(root) NOPASSWD:/var/www/html/vuln.sh' >> /etc/sudoers
echo 'www-data ALL=(root) NOPASSWD:/var/www/html/ufw.sh' >> /etc/sudoers

# Set Up HTTP Auth
echo "Please set a password to protect the web interface..."
sleep 10
htpasswd -c /etc/apache2/.htpasswdmain ben #Create .htaccess file to store user login hash
mv ~/pi-securenet/000-default.conf /etc/apache2/sites-enabled/
mv ~/pi-securenet/apache2.conf /etc/apache2/
service apache2 restart
