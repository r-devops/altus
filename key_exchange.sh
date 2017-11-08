#!/bin/bash

clear
echo -n -e "Enter Public Key: "
read key
echo $key >/tmp/sshkey
ssh-keygen -lf /tmp/sshkey &>/dev/null
if [ $? -ne 0 ]; then
        echo "Provideed Key is not a valid one"
        exit 1
fi
mkdir -p ~/.ssh
chmod 700 ~/.ssh
KEY=$(echo $key | awk '{print $2}')
if [ -f ~/.ssh/authorized_keys ]; then
        grep "$KEY" ~/.ssh/authorized_keys &>/dev/null
        if [ $? -eq 0 ]; then
          LINE=$(cat -n ~/.ssh/authorized_keys | grep "$KEY" |awk '{print $1}')
          sed -i -e "$LINE d" ~/.ssh/authorized_keys
        fi
fi

echo $key >>~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo "Key added successfully"
