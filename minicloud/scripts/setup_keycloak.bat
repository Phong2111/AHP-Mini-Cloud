@echo off
echo [*] Dang cau hinh Keycloak Realm, Users va Client...
echo (Luu y: Keycloak can khoang 30-60s de hoan toan khoi dong truoc khi lam buoc nay)
docker exec authentication-identity-server /opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080/ --realm master --user admin --password admin
docker exec authentication-identity-server /opt/keycloak/bin/kcadm.sh create realms -s realm=realm_sv001 -s enabled=true
docker exec authentication-identity-server /opt/keycloak/bin/kcadm.sh create users -r realm_sv001 -s username=sv01 -s enabled=true -s "credentials=[{\"type\":\"password\",\"value\":\"123456\",\"temporary\":false}]"
docker exec authentication-identity-server /opt/keycloak/bin/kcadm.sh create users -r realm_sv001 -s username=sv02 -s enabled=true -s "credentials=[{\"type\":\"password\",\"value\":\"123456\",\"temporary\":false}]"
docker exec authentication-identity-server /opt/keycloak/bin/kcadm.sh create clients -r realm_sv001 -s clientId=flask-app -s publicClient=true -s directAccessGrantsEnabled=true -s defaultClientScopes=[\"web-origins\",\"acr\",\"profile\",\"roles\",\"email\"] -s "redirectUris=[\"http://localhost/*\"]"
echo [OK] Keycloak Automation Completed!
