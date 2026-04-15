@echo off
echo [*] Dang cau hinh MinIO... (Tao bucket profile-pics va documents)
docker run --rm --network cloud-net --entrypoint sh minio/mc -c "mc alias set myminio http://object-storage-server:9000 minioadmin minioadmin && mc mb myminio/profile-pics --ignore-existing && mc mb myminio/documents --ignore-existing && mc anonymous set public myminio/profile-pics && mc anonymous set public myminio/documents"

echo [*] Dang upload avatar mau len MinIO (profile-pics)...
docker run --rm --network cloud-net --entrypoint sh minio/mc -c "mc alias set myminio http://object-storage-server:9000 minioadmin minioadmin && wget -qO /tmp/avatar.jpg 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200' && mc cp /tmp/avatar.jpg myminio/profile-pics/avatar.jpg"

echo [*] Tao file PDF bao cao mau va upload len MinIO (documents)...
docker run --rm --network cloud-net --entrypoint sh minio/mc -c "mc alias set myminio http://object-storage-server:9000 minioadmin minioadmin && echo 'BÁO CÁO ĐỒ ÁN - MyMiniCloud' > /tmp/baocao.pdf && mc cp /tmp/baocao.pdf myminio/documents/baocao-dotán.pdf"

echo [OK] MinIO Automation Completed!
echo [*] Kiem tra cac file da upload:
docker run --rm --network cloud-net --entrypoint sh minio/mc -c "mc alias set myminio http://object-storage-server:9000 minioadmin minioadmin && mc ls myminio/profile-pics && mc ls myminio/documents"
