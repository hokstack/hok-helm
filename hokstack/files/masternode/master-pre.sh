#!/bin/bash
cp -rf /etc/hosts /hosts-new
sed -i '$d' /hosts-new
sed -i '11 s/^/#/' /etc/pam.d/su
echo $PODIP $PODNAME.$NAMESPACE $PODNAME >> /hosts-new
yes|cp -rf /hosts-new /etc/hosts
hostname $PODNAME
echo $PODNAME > /etc/hostname
/scripts/master-ssh-config.sh
echo "AllowUsers *@10.42.*.*" >> sshd_config