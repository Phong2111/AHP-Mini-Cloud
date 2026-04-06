@echo off
echo [*] Dang cau hinh MinIO... (Tao bucket profile-pics va documents)
docker run --rm --network cloud-net --entrypoint sh minio/mc -c "mc alias set myminio http://object-storage-server:9000 minioadmin minioadmin && mc mb myminio/profile-pics --ignore-existing && mc mb myminio/documents --ignore-existing && mc anonymous set public myminio/profile-pics && mc anonymous set public myminio/documents"
echo [*] Dang upload avatar mau len MinIO...
docker run --rm --network cloud-net --entrypoint sh minio/mc -c "mc alias set myminio http://object-storage-server:9000 minioadmin minioadmin && wget -qO /tmp/avatar.jpg 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200' && mc cp /tmp/avatar.jpg myminio/profile-pics/avatar.jpg"
echo [OK] MinIO Automation Completed!
