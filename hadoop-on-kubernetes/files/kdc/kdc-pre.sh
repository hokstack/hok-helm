#!/bin/bash
cp -rf /etc/hosts /hosts-new
sed -i '$d' /hosts-new
echo $PODIP $PODNAME >> /hosts-new
yes|cp -rf /hosts-new /etc/hosts
hostname $PODNAME
echo $PODNAME > /etc/hostname