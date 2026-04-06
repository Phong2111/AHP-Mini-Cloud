# AHP-Mini-Cloud

## 1. Mô tả dự án

Dự án **AHP-Mini-Cloud** là một hệ thống điện toán đám mây thu nhỏ được xây dựng nhằm mục đích mô phỏng và giảng dạy các khái niệm cơ bản của điện toán đám mây. Hệ thống bao quát toàn bộ quy trình thiết lập nền tảng web, proxy, cơ sở dữ liệu, kho lưu trữ lớn và cả các hệ thống giám sát metric. Đặc biệt, giao diện web được thiết kế theo phong cách Glassmorphism cao cấp cùng một loạt kịch bản tự động hóa giúp sinh viên triển khai với tốc độ nhanh nhất.

## 2. Các thành phần chính (10 Servers)

### 2.1. Các thành phần ứng dụng (Application Layer)
- **Web Frontend Server (2 nodes)**: Cung cấp giao diện Landing Page và Blog có thiết kế UI siêu xịn. Sử dụng 2 node `web1` và `web2` chạy song song để minh họa công nghệ cân bằng tải (Load Balancing).
- **Application Backend Server**: Cung cấp API nội bộ (chạy nền Flask, cổng `8085`), có chức năng xác minh bảo mật JWT Token và tra cứu dữ liệu sinh viên từ file JSON/Database.
- **Relational Database Server**: Cơ sở dữ liệu MariaDB tự động tạo hai Databases `minicloud` và `studentdb`.
- **Object Storage Server**: Máy chủ lưu trữ đối tượng MinIO. Tự động khởi tạo các bucket `profile-pics` và `documents`, giả lập hệ thống Amazon S3.

### 2.2. Các thành phần hạ tầng (Infrastructure Layer)
- **Internal DNS Server**: Cung cấp tên miền ảo (BIND9) dùng chung trong mạng `cloud-net` (VD: `minio.cloud.local`, `app-backend.cloud.local`).
- **API Gateway Proxy Server**: Máy chủ Nginx đứng cửa chặn đầu làm cổng ra vào chung (Cổng ảo `80`), điều phối Request về 2 Web Backend theo thuật toán *Round Robin*, có Proxy API, Load Balancer mạnh mẽ.

### 2.3. Các thành phần quản lý và giám sát (Management & Monitoring Layer)
- **Authentication Identity Server**: Hệ thống Login/SSO quản trị Token dùng Keycloak (Cổng `8181`). Tự động tải lên Realm `realm_sv001` cùng hàng loạt User sinh viên có sẵn.
- **Monitoring Node Exporter Server**: Tool lấy chỉ số kỹ thuật thô của máy.
- **Monitoring Prometheus Server**: Cỗ máy lấy số liệu định kỳ từ Node-exporter và Web server.
- **Monitoring Grafana Dashboard Server**: Tool trực quan biểu đồ. Tự động gán Dashboard "System Health of MSSV" hiển thị Network, CPU và RAM.

## 3. Công nghệ sử dụng
- **Điều phối Container**: Docker & Docker Compose V2
- **Tự động hóa Script**: Bash/CMD thao tác cấu hình (`kcadm.sh` & `minio/mc`)
- **Web Frontend**: HTML5/CSS3 (Glassmorphism, CSS Mesh Gradients)
- **Application Backend**: Python (Flask, python-jose)
- **Database**: MariaDB
- **Object Storage**: MinIO
- **Identity & SSO**: Keycloak 24+
- **Proxy/Gateway**: Nginx
- **Monitoring**: Prometheus, Grafana, Node Exporter
- **Private DNS**: Bind9

---

## 4. Hướng dẫn Khởi chạy "1 Click"

### BƯỚC 1: Build và khởi động 10 máy chủ
1. Mở PowerShell hoặc Terminal của bạn.
2. Điều hướng vào thư mục `minicloud`:
   ```powershell
   cd minicloud
   ```
3. Chạy lệnh up để tải ảnh (chỉ mất lâu lúc đầu) và khởi động toàn bộ:
   ```powershell
   docker compose down -v
   docker compose up -d --build
   ```

### BƯỚC 2: Chạy Tự Động Hóa 
Thay vì dùng tay cấu hình hàng chục bước theo yêu cầu môn học, hãy tận dụng các script tự động. Trong PowerShell, bạn đi vào thư mục `scripts` rồi chạy chúng:

```powershell
cd scripts

# 1. Chạy setup MinIO (Sẽ tự động tạo Bucket, mở Public, ném ảnh Avatar.jpg qua web)
.\setup_minio.bat

# 2. Chạy setup Keycloak (Sẽ tự động tạo Realm sinh viên, Client, cấp tài khoản sv01, sv02 mật khẩu 123456)
# Lưu ý: Chạy lệnh này sau khi Keycloak up khoảng 30s-1 phút để server Java kịp khởi động
.\setup_keycloak.bat
```

### BƯỚC 3: Trải nghiệm thực tế
Trải nghiệm truy cập các hệ thống vừa dựng bằng trình duyệt Web của bạn:

1. **Trang Giao Diện Đám Mây Mới (Premium Web)**
   - Link: [http://localhost:8084](http://localhost:8084) hoặc [http://localhost:8083](http://localhost:8083) hoặc thông qua cổng Proxy tổng `http://localhost/`.
   - Vào tận hưởng giao diện HTML CSS xịn xò với Animation mượt mà.

2. **Hệ thống Biểu Đồ Grafana Automation**
   - Link: [http://localhost:3000](http://localhost:3000) (Tài khoản mặc định: `admin` / `admin`).
   - Ngay sau màn hình login, bạn sẽ thấy `Dashboards -> System Health`. Vào xem ngay biểu đồ CPU và Truyền tải do Prometheus tự cấu hình.

3. **Kho Lưu Trữ MinIO**
   - Link: [http://localhost:9000](http://localhost:9000) (Tài khoản: `minioadmin` / `minioadmin`).
   - Trong thẻ `Buckets`, bạn sẽ thấy cái `profile-pics` và có chứa file hình tải về từ Unsplash.

4. **Trang Xác Thực SSO Keycloak**
   - Link: [http://localhost:8181](http://localhost:8181)

## 5. Các bước Nộp Phụ Lục (Bắt buộc chèn vào báo cáo môn học)

Sau khi kiểm thử hoạt động suôn sẻ mọi thứ, bạn sẽ phải làm 3 phần Phụ Lục này để nộp.

### Phụ Lục A: Đăng ảnh Web lên Docker Hub
1. Đăng nhập Docker:
   ```powershell
   docker login
   ```
2. Gắn mác Docker Ảnh với tên User (đổi ID `<ten_cua_ban>`):
   ```powershell
   docker tag minicloud-web-frontend-server1 <ten_cua_ban>/myminicloud-web:v1.0
   ```
3. Đẩy lên và lưu vào Word cái Link đó:
   ```powershell
   docker push <ten_cua_ban>/myminicloud-web:v1.0
   ```

### Phụ Lục B: Xả Log máy chủ nộp Giảng viên
Lệnh này sẽ trút toàn bộ Log của ứng dụng hệ thống để Giảng Viên tra soát (Chạy trong thư mục `minicloud`):
```powershell
docker compose logs > hethong-minicloud-logs.txt
```

### Phụ Lục C: Quay Video Demo
Sử dụng OBS hoặc công cụ quay phim, chiếu màn hình Browser của bạn truy cập hết 4 Link ở Bước 3. Up Youtube lên link ẩn và nộp link.