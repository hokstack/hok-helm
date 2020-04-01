#!/bin/bash
cp -rf /etc/hosts /hosts-new
sed -i '$d' /hosts-new
echo $PODIP $PODNAME.$NAMESPACE $PODNAME >> /hosts-new
yes|cp -rf /hosts-new /etc/hosts
hostname $PODNAME
echo $PODNAME > /etc/hostname
bash /usr/bin/postgresql-setup initdb
yes|cp -rf /postgresql.conf /var/lib/pgsql/data/postgresql.conf
chown -v postgres.postgres /var/lib/pgsql/data/postgresql.conf
mv /var/lib/pgsql/data/pg_hba.conf /var/lib/pgsql/data/pg_hba.conf-orig
echo "local all all trust" >> /var/lib/pgsql/data/pg_hba.conf
echo "host all all 0.0.0.0/0 trust" >> /var/lib/pgsql/data/pg_hba.conf
usermod -G wheel postgres
