@echo off
echo [*] Kiem tra phan giai DNS (Yeu cau Mo rong 6)...
echo.
echo [1] Kiem tra app-backend.cloud.local:
docker run --rm --network cloud-net --entrypoint dig internetsystemsconsortium/bind9:9.18 @internal-dns-server app-backend.cloud.local +short
echo.
echo [2] Kiem tra minio.cloud.local:
docker run --rm --network cloud-net --entrypoint dig internetsystemsconsortium/bind9:9.18 @internal-dns-server minio.cloud.local +short
echo.
echo [3] Kiem tra keycloak.cloud.local:
docker run --rm --network cloud-net --entrypoint dig internetsystemsconsortium/bind9:9.18 @internal-dns-server keycloak.cloud.local +short
echo.
echo [*] Hoan tat kiem tra DNS! Mọi IP đều trỏ về 10.10.10.x là hợp lệ.
