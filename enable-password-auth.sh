#!/bin/bash

### Note: I dont recomend this script in real times, It is only for Lab purpose.
chattr -i /etc/ssh/sshd_config
sed -i -e '/#PermitRootLogin/ c PermitRootLogin yes' -e '/^PermitRootLogin/ s/no/yes/' -e '/^PasswordAuthentication/ c PasswordAuthentication yes' /etc/ssh/sshd_config
echo 'echo -n -e "\e[31mEnter ROOT password: \e[0m"
read pass
noc=$(echo $pass |wc -c)
if [ $noc -lt 9 ]; then
        echo -e "\e[34m Root Password should be Minimum 8 characters\e[0m"
        echo "Try Again"
        exit 1
fi
echo $pass | passwd --stdin root &>/dev/null' >/tmp/set_root_pass 
sh /tmp/set_root_pass

systemctl restart sshd
