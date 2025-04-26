# 🚀 Hướng Dẫn Thiết Lập và Triển Khai Cơ Sở Hạ Tầng AWS với Terraform

Hướng dẫn này sẽ thiết lập và triển khai cơ sở hạ tầng AWS bằng Terraform.  
Bao gồm các bước cài đặt công cụ, tạo khóa SSH và chạy dự án Terraform từng bước.

---

## 📦 Tổng Quan Dự Án

Cơ sở hạ tầng bao gồm:

- Một VPC với các subnet công khai và riêng tư  
- Internet Gateway và NAT Gateway  
- Bảng định tuyến (Route Tables) cho định tuyến công khai và riêng tư  
- Nhóm bảo mật (Security Groups) cho các phiên bản EC2 công khai và riêng tư  
- Các phiên bản EC2 được triển khai trong cả subnet công khai và riêng tư

---

## ⚙️ Yêu Cầu Trước Khi Bắt Đầu

Trước khi chạy Terraform, cần cài đặt các công cụ sau:

### 1️⃣ Cài Đặt Terraform

- Tải về: [https://developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/downloads)  
- Giải nén và thêm `terraform` vào PATH của hệ thống  
- Kiểm tra:

```bash
terraform version
```

### 2️⃣ Cài Đặt AWS CLI

- Tải về: [https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)  
- Cấu hình thông tin xác thực:

```bash
aws configure
```

Cung cấp:

- AWS Access Key  
- AWS Secret Key  
- Vùng mặc định (ví dụ: `ap-southeast-1`)  
- Định dạng đầu ra (ví dụ: `json`)

---

## 🔑 Tạo Cặp Khóa SSH (Cho EC2 Instances)

### Tạo thư mục để lưu khóa

```bash
mkdir keypair
```

### Tạo khóa SSH mới

```bash
ssh-keygen -t rsa -b 4096 -C "youremail@gmail.com" -f ./keypair/lab1-keypair
```

Kết quả:

- `lab1-keypair`: tệp khóa riêng  
- `lab1-keypair.pub`: tệp khóa công khai

### Chmod file keypair ở local

```bash
chmod 400 ./keypair/lab1-keypair
```

---

## 🌐 Lấy Địa Chỉ IP Công Khai (Cho Truy Cập SSH)

```bash
curl https://checkip.amazonaws.com
```

Thêm `/32` vào địa chỉ IP và đặt trong `terraform.tfvars` dưới biến `allowed_ssh_ip`:

```hcl
allowed_ssh_ip = "123.45.67.89/32"
```

---

## 📁 Ví Dụ Tệp `terraform.tfvars`

```hcl
region               = "ap-southeast-1"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24"]
private_subnet_cidrs = ["10.0.2.0/24"]
allowed_ssh_ip       = "123.45.67.89/32"
ami_id               = "ami-05ab12222a9f39021"
instance_type        = "t2.micro"
key_name             = "lab1-keypair"
```

---

## 🚀 Chạy Dự Án

### Bước 1: Khởi Tạo Terraform

```bash
terraform init
```

### Bước 2: Xem Trước Tài Nguyên Sẽ Được Tạo

```bash
terraform plan
```

### Bước 3: Triển Khai Cơ Sở Hạ Tầng

```bash
terraform apply
```

Nhập `yes` khi được yêu cầu.

---

## 🔐 Kết Nối Với EC2 Instances

## Copy keypair từ local lên Public EC2

```bash
scp -i ./keypair/lab1-keypair ./keypair/lab1-keypair ec2-user@<Public-IP>:~/
```

### Public EC2 Instance:

```bash
ssh -i ./keypair/lab1-keypair ec2-user@<Public-IP>
```

###  Chmod file keypair trong Public EC2

```bash
chmod 400 ~/lab1-keypair
```

### Từ Public EC2 Instance → SSH đến Private EC2 Instance:

```bash
ssh -i ~/lab1-keypair ec2-user@<Private-IP>
```

---

## ✅ Dọn Dẹp (Tùy Chọn)

Để xóa tất cả tài nguyên đã tạo:

```bash
terraform destroy
```

---

## 📄 Thông Tin Bổ Sung

- Trường hợp kiểm thử: xem `tests_manual.md`
