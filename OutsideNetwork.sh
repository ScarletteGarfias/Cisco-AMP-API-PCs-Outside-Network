#!/bin/bash

Outside=$(curl 'https://api.amp.cisco.com/v1/computers?group_guid=GROUPID' -u 'ClientID:Key' | jq \
| grep 'external\|hostname\|last_seen\|is_compromised' | paste - - - - | column -t -s$'\t' | grep -v '8.8.8.8' | grep $(date +%Y-%m) | wc -l)


if [[ $Outside -gt "0" ]]; then

cp /home/Sendmail.txt /home/Sendmailtemplate.txt
echo "Subject: Computers Outside the Network" >> /home/Sendmailtemplate.txt
echo  >> /home/Sendmailtemplate.txt

curl 'https://api.amp.cisco.com/v1/computers?group_guid=GROUPID' -u 'ClientID:Key' | jq \
| grep 'external\|hostname\|last_seen\|is_compromised' | paste - - - - | column -t -s$'\t' \
| grep -v '8.8.8.8' | grep $(date +%Y-%m) >> /home/Sendmailtemplate.txt

sudo cat /Sendmailtemplate.txt | ssmtp user@email.com

rm /home/Sendmailtemplate.txt

fi
