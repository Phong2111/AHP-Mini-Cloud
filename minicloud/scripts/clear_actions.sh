#!/bin/sh
/opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080/ --realm master --user admin --password admin
USER1=$(/opt/keycloak/bin/kcadm.sh get users -r realm_sv001 -q username=sv01 | grep -o '"id" : "[^"]*' | head -1 | awk -F'"' '{print $4}')
USER2=$(/opt/keycloak/bin/kcadm.sh get users -r realm_sv001 -q username=sv02 | grep -o '"id" : "[^"]*' | head -1 | awk -F'"' '{print $4}')
/opt/keycloak/bin/kcadm.sh update users/$USER1 -r realm_sv001 -s 'requiredActions=[]'
/opt/keycloak/bin/kcadm.sh update users/$USER2 -r realm_sv001 -s 'requiredActions=[]'
