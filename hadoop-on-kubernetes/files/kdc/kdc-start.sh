#!/bin/bash
kdb5_util create -s -P hadoop
service krb5kdc start
chkconfig krb5kdc on
service kadmin start
chkconfig kadmin on
tail -f /var/log/krb5kdc.log