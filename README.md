# Pi SecureNET
Pi-SecureNET is a project where backend network recon marries web design to create an attractive yet effective interface to provide network visibility and vulnerability management off of $15 hardware

The backend leverages php to run the bash scripts that use nmap to scan the network. The challenge was getting the results of the bash scripts into a readable, visually appealing format. With the help of the 'Nicepage' app for Mac, I was able to build a site that had empty tables on each respective page. From here, it gets really jenky. I'll admit it and any web-devs out there reading this are most definetly viscerally shuddering at this point but my background is in network and security, not web design so this was the easiest way for me to make it work. 

Disclaimer aside, those empty tables have a table item string that I can pad each scan result with. During the install, each template HTML page is split into two parts: the half before the table items, and the half after them. When the php file calls the bash script, the script prints the first half of the HTML (up to the table), runs the scans, formats them as HTML table items, and then prints the last half of the HTML. The result is a dynamically-populated HTML page that displays just like any other. 

## Thoughts for The Future
* 2FA Implementation
   * Main password for index.html and auto php key push to get to nested pages
* Differential scan push notifications (new host on network)

## Testing Environment
This project was built and tested on the Raspberry Pi Zero 2W with Ubuntu Server 21.10 32-bit.

# References
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

