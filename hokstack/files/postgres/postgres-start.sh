#!/bin/bash
sleep 30
su postgres -c 'pg_ctl start -w -D /var/lib/pgsql/data'
sleep 10
bash /100-db-create.sh
sleep 10
tail -f /dev/null
