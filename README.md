# Pi SecureNET
Pi-SecureNET is a project where backend network recon marries web design to create an attractive yet effective interface to provide network visibility and vulnerability management off of $15 hardware.

![](https://github.com/ben3636/pi-securenet/blob/main/screenshots/Screen%20Shot%202021-11-14%20at%202.49.21%20PM.png)
![](https://github.com/ben3636/pi-securenet/blob/main/screenshots/Updated%20Discovery%20Demo.png)

The backend leverages php to run the bash scripts that use nmap to scan the network. The challenge was getting the results of the bash scripts into a readable, visually appealing format. With the help of the 'Nicepage' app for Mac, I was able to build a site that had empty tables on each respective page. From here, it gets really jenky. I'll admit it and any web-devs out there reading this are most definetly viscerally shuddering at this point but my background is in network and security, not web design so this was the easiest way for me to make it work. 

Disclaimer aside, those empty tables have a table item string that I can pad each scan result with. During the install, each template HTML page is split into two parts: the half before the table items, and the half after them. When the php file calls the bash script, the script prints the first half of the HTML (up to the table), runs the scans, formats them as HTML table items, and then prints the last half of the HTML. The result is a dynamically-populated HTML page that displays just like any other. 

The coolest part of this entire project is that it can be built for under $20. No, it's not as full-featured as other vulnerability scanners but for something that works beautifully on $15 hardware half the size of a credit card, it's pretty damn cool. 

>NOTE: The default HTTP auth user is 'ben', you can change this in the install script if desired 

> The IP in the HTML pages is also hard-coded, the install script runs the ip-update.sh script to update the IP in the HTML to that of the Pi. If the IP changes after the install, you can manually run the ip-update.sh script to fix the broken links :)

![](https://github.com/ben3636/pi-securenet/blob/main/screenshots/Updated%20Firewall%20Demo.png)
![](https://github.com/ben3636/pi-securenet/blob/main/screenshots/Screen%20Shot%202021-11-14%20at%202.49.45%20PM.png)

## New Features (Available)
### Scheduled Differential Discovery Scans
You're probably asking yourself what that means. Differential scanning is a way of scanning for deviation from the established basline. What this means in the context of this project is this:

1. During setup, you run a discovery scan until you see the results that you feel are "baseline"
  a) Are these all the hosts you expect to see on your network?
  b) If the answer is yes, the result is saved to a "baseline" file
2. After the baseline is established, an hourly cronjob runs a quick discovery scan over the subnet and compares it to the baseline
  a) This comparison logic is looking for host additions, or new hosts that are not listed in the baseline file
  b) If a new host is detected, a push notification is sent to your phone with the IP, hostname, etc
  
 > This feature is out of beta but needs to be configured manually. The file "differential-push" will need to be updated with your IFTT webhook. From there, just drop it in /etc/cron.hourly/ and run the "generate-baseline.sh" script to create the normal/baseline results
 
 > IFTTT Webhooks Setup Tutorial: https://youtu.be/l-YP8uSJ9Q0

> If a new device shows up after generating the baseline, you can now "whitelist" devices by adding them to the baseline file. To do this, just use PI_IP_ADDRESS/whitelist.php :)

### Device Naming (Discovery Scan Page)
You can now set custom names for devices so you're never left guessing! Do this by visiting PI_IP_ADDRESS/alias.php. Throw in the device's MAC address and set a name and the device will show up with the preferred name going forward!

## Features in Beta
* Home page re-organized and optimized for mobile
* Vulnerability scan results in cleaner format
* Visual overhaul of newer pages (aias.php and whitelist.php)
* Actual links to newer pages (alias.php and whitelist.php)

## Thoughts for The Future
* 2FA Implementation
   * Main password for index.html and auto php key push to get to nested pages
* Ability to manage firewall rules for devices via web interface (block internet, etc)
* Combine previous Pi IDS project to provide Suricata push notifications
* Zeek for activity monitoring, audit capibility, and indident response

## Testing Environment
This project was built and tested on the Raspberry Pi Zero 2W with Ubuntu Server 21.10 32-bit.

## References
* HTTP Auth: 
   * https://www.digitalocean.com/community/tutorials/how-to-set-up-password-authentication-with-apache-on-ubuntu-14-04
* 2FA:
   * https://www.linuxjournal.com/content/two-factor-authentication-system-apache-and-ssh
* Enabling embedded PHP:
   * https://stackoverflow.com/questions/21279901/php-gets-commented-out-in-html
* RPI Zero 2 Ubuntu Server Bug Fix:
   * https://bugs.launchpad.net/ubuntu/+source/initramfs-tools/+bug/1950214
* Misc
   * https://stackoverflow.com/questions/21279901/php-gets-commented-out-in-html
   * https://www.ionos.com/digitalguide/server/configuration/password-protect-a-directory-with-apache/

