@echo off
echo [*] Dang xin quyen lay Token tu Keycloak (Yeu cau Mo rong 4)...
echo.

curl -s -X POST "http://localhost:8181/realms/realm_sv001/protocol/openid-connect/token" ^
  -H "Content-Type: application/x-www-form-urlencoded" ^
  -d "username=sv01" ^
  -d "password=123456" ^
  -d "grant_type=password" ^
  -d "client_id=flask-app" > token_response.json

echo [*] Phan hoi tu Keycloak gium dang Token tra ve (token_response.json):
type token_response.json
echo.
echo.
echo [*] Xin quyen lay Token hoan tat! Tra ve "access_token" dài là thành công.
