# #!/bin/bash
source ./env.sh
echo "Creating admin princ in KDC"

kubectl exec -it kdcserver-0 -n $TEAM_NAME  -- kadmin.local -q "addprinc -pw $PASSWORD $USER/admin@$REALM"

retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Error creating the princ"
    else echo "Princ created, please use $USER/admin@$REALM while kerberising hdp"
fi
