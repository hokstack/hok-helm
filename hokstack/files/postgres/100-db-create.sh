#!/bin/bash

#Hive Metastore DB Creation
echo "CREATE DATABASE $HIVEDB;" | psql -U postgres -h postgres-0
echo "CREATE USER hiveuser  WITH PASSWORD '123456789';" | psql -U postgres -h postgres-0
echo "GRANT ALL PRIVILEGES ON DATABASE metastore TO $HIVEUSER;" | psql -U postgres -h postgres-0

#Oozie DB Creation
echo "CREATE DATABASE $OOZIEDB;" | psql -U postgres -h postgres-0
echo "CREATE USER oozieuser WITH PASSWORD '123456789';" | psql -U postgres -h postgres-0
echo "GRANT ALL PRIVILEGES ON DATABASE oozie TO $OOZIEUSER;" | psql -U postgres -h postgres-0

psql -v ON_ERROR_STOP=1 --username "postgres"  -h postgres-0 <<-EOSQL
    create database ambari;
    create user ambari with password 'dev';
    GRANT ALL PRIVILEGES ON DATABASE ambari TO ambari;

    CREATE SCHEMA ambari AUTHORIZATION ambari;
    ALTER SCHEMA ambari OWNER TO ambari;
    ALTER SCHEMA public OWNER to ambari;

    ALTER ROLE ambari SET search_path to 'ambari', 'public';

    \connect ambari ambari;
    \i Ambari-DDL-Postgres-CREATE.sql
EOSQL
