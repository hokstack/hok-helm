#!/bin/bash

#Script source: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-kerberos-configuration-users.html

#Declare an associative array of user names and passwords to add
declare -A arr
arr=([user1]=password1 [user2]=password2 [richardroe]=password3)
for i in ${!arr[@]}; do
    #Assign plain language variables for clarity
     name=${i} 
     password=${arr[${i}]}

     # Create a principal for each user in the master node and require a new password on first logon
     sudo kadmin.local -q "addprinc -pw $password +needchange $name"
     sudo kadmin.local -q "ktadd -k /tmp/$name.keytab $name"

     #Add hdfs directory for each user
     hdfs dfs -mkdir /user/$name

     #Change owner of each user's hdfs directory to that user
     hdfs dfs -chown $name:$name /user/$name
done