#!/bin/bash
echo "New Key Created!"
key=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 5)
message="Pi IDS 2FA Key Is: "
curl -X POST -H "Content-Type: application/json" -d '{"value1":"'"$message"'","value2":"'"$key"'","value3":"'""'"}' https://maker.ifttt.com/trigger/Pi-IDS/with/key/UntimRA5FlDbyVp5GRuNU >> /dev/null
htpasswd -b /home/ben/.htpasswd ben $key
