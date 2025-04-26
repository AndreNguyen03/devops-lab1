# Kiểm Thử Thủ Công Hạ Tầng Terraform

Dưới đây là các test case thủ công (manual test cases) được viết chi tiết để kiểm tra hạ tầng AWS được triển khai bằng Terraform. Các test case sử dụng các output từ các module (`compute`, `vpc`,`route_table`,`nat_gateway`, `security`, `main`) để xác minh tài nguyên được tạo đúng như mong đợi.

---

## 1. VPC

### Test Case 1.1: Kiểm tra VPC được tạo đúng CIDR
- **Mô tả**: Xác minh rằng VPC được tạo với CIDR chính xác (`10.0.0.0/16`) và có ID khớp với output `vpc_id` từ module `vpc` và `main`.
- **Điều kiện tiên quyết**:
  - Terraform đã được áp dụng thành công (`terraform apply`).
  - Có output `vpc_id` từ module `vpc` và `main`.
  - Đã đăng nhập vào AWS Console với quyền truy cập vào dịch vụ VPC.
- **Các bước thực hiện**:
  1. Chạy lệnh để xem output của Terraform:
     ```bash
     terraform output vpc_id
     ```
     Ghi lại giá trị `vpc_id` (ví dụ: `vpc-12345678`).
  2. Đăng nhập vào AWS Management Console.
  3. Điều hướng đến **VPC Dashboard** → **Your VPCs**.
  4. Tìm VPC có ID khớp với `vpc_id` từ output.
  5. Nhấp vào VPC để xem chi tiết.
  6. Kiểm tra trường **IPv4 CIDR** trong phần thông tin.
- **Kết quả mong đợi**:
  - VPC tồn tại với ID khớp với output `vpc_id`.
  - VPC hiển thị CIDR là `10.0.0.0/16`.
- **Output mẫu**:
  ```
  Terraform output:
  vpc_id = "vpc-12345678"

  AWS Console:
  VPC ID: vpc-12345678
  Name: <tag-name>
  IPv4 CIDR: 10.0.0.0/16
  ```
- **Kết quả kiểm thử**:
  - [ ] Pass: VPC hiển thị đúng CIDR `10.0.0.0/16` và ID khớp với `vpc_id`.
  - [ ] Fail: VPC không tồn tại, CIDR không khớp, hoặc ID không khớp.

---

## 2. Subnets

### Test Case 2.1: Kiểm tra Public Subnet có route ra Internet Gateway
- **Mô tả**: Xác minh rằng Public Subnet (dựa trên `public_subnet_ids` từ module `vpc`) được cấu hình với một route dẫn đến Internet Gateway (dựa trên `igw_id`).
- **Điều kiện tiên quyết**:
  - Terraform đã được áp dụng thành công.
  - Có output `public_subnet_ids` và `igw_id` từ module `vpc`.
  - Đã đăng nhập vào AWS Console với quyền truy cập vào dịch vụ VPC.
- **Các bước thực hiện**:
  1. Chạy lệnh để xem output của Terraform:
     ```bash
     terraform output public_subnet_ids
     terraform output igw_id
     ```
     Ghi lại giá trị `public_subnet_ids` (ví dụ: `["subnet-12345678"]`) và `igw_id` (ví dụ: `igw-abcdefgh`).
  2. Đăng nhập vào AWS Management Console.
  3. Điều hướng đến **VPC Dashboard** → **Subnets**.
  4. Tìm subnet có ID khớp với một trong các ID trong `public_subnet_ids`.
  5. Ghi lại **Route Table** được liên kết với Public Subnet.
  6. Điều hướng đến **Route Tables**, chọn Route Table tương ứng.
  7. Kiểm tra trong tab **Routes** xem có tuyến đường đến `0.0.0.0/0` với đích là Internet Gateway có ID khớp với `igw_id` hay không.
- **Kết quả mong đợi**:
  - Route Table của Public Subnet có tuyến đường:
    ```
    Destination: 0.0.0.0/0
    Target: igw-abcdefgh (khớp với igw_id)
    ```
- **Output mẫu**:
  ```
  Terraform output:
  public_subnet_ids = ["subnet-12345678"]
  igw_id = "igw-abcdefgh"

  AWS Console:
  Route Table ID: rtb-12345678
  Routes:
    Destination: 10.0.0.0/16, Target: local
    Destination: 0.0.0.0/0, Target: igw-abcdefgh
  ```
- **Kết quả kiểm thử**:
  - [ ] Pass: Tuyến đường đến Internet Gateway tồn tại và khớp với `igw_id`.
  - [ ] Fail: Không có tuyến đường đến `0.0.0.0/0` hoặc đích không phải `igw_id`.

### Test Case 2.2: Kiểm tra Private Subnet có route ra NAT Gateway
- **Mô tả**: Xác minh rằng Private Subnet (dựa trên `private_subnet_ids` từ module `vpc`) được cấu hình với một route dẫn đến NAT Gateway (dựa trên `nat_gateway_id`).
- **Điều kiện tiên quyết**:
  - Terraform đã được áp dụng thành công.
  - Có output `private_subnet_ids` và `nat_gateway_id` từ module `vpc`, `nat_gateway`.
  - Đã đăng nhập vào AWS Console với quyền truy cập vào dịch vụ VPC.
- **Các bước thực hiện**:
  1. Chạy lệnh để xem output của Terraform:
     ```bash
     terraform output private_subnet_ids
     terraform output nat_gateway_id
     ```
     Ghi lại giá trị `private_subnet_ids` (ví dụ: `["subnet-87654321"]`) và `nat_gateway_id` (ví dụ: `nat-ijklmnop`).
  2. Đăng nhập vào AWS Management Console.
  3. Điều hướng đến **VPC Dashboard** → **Subnets**.
  4. Tìm subnet có ID khớp với một trong các ID trong `private_subnet_ids`.
  5. Ghi lại **Route Table** được liên kết với Private Subnet.
  6. Điều hướng đến **Route Tables**, chọn Route Table tương ứng.
  7. Kiểm tra trong tab **Routes** xem có tuyến đường đến `0.0.0.0/0` với đích là NAT Gateway có ID khớp với `nat_gateway_id` hay không.
- **Kết quả mong đợi**:
  - Route Table của Private Subnet có tuyến đường:
    ```
    Destination: 0.0.0.0/0
    Target: nat-ijklmnop (khớp với nat_gateway_id)
    ```
- **Output mẫu**:
  ```
  Terraform output:
  private_subnet_ids = ["subnet-87654321"]
  nat_gateway_id = "nat-ijklmnop"

  AWS Console:
  Route Table ID: rtb-87654321
  Routes:
    Destination: 10.0.0.0/16, Target: local
    Destination: 0.0.0.0/0, Target: nat-ijklmnop
  ```
- **Kết quả kiểm thử**:
  - [ ] Pass: Tuyến đường đến NAT Gateway tồn tại và khớp với `nat_gateway_id`.
  - [ ] Fail: Không có tuyến đường đến `0.0.0.0/0` hoặc đích không phải `nat_gateway_id`.

---

## 3. Security Groups

### Test Case 3.1: Kiểm tra SSH vào Public EC2 từ IP được phép
- **Mô tả**: Xác minh rằng có thể SSH vào Public EC2 (dựa trên `public_instance_id` từ module `compute`) từ địa chỉ IP được phép, sử dụng Security Group (`public_sg_id` từ module `security`).
- **Điều kiện tiên quyết**:
  - Terraform đã được áp dụng thành công.
  - Có output `public_instance_id` từ module `compute` và `public_sg_id` từ module `security`.
  - Đã có tệp khóa SSH (`lab1-keypair`) và địa chỉ IP công khai của Public EC2 (từ AWS Console hoặc Terraform output).
  - Địa chỉ IP của máy kiểm thử đã được thêm vào `your_ip` trong `terraform.tfvars`.
- **Các bước thực hiện**:
  1. Chạy lệnh để xem output của Terraform:
     ```bash
     terraform output public_instance_id
     terraform output public_sg_id
     ```
     Ghi lại giá trị `public_instance_id` (ví dụ: `i-1234567890abcdef0`) và `public_sg_id` (ví dụ: `sg-12345678`).
  2. Đăng nhập vào AWS Console, điều hướng đến **EC2** → **Instances**.
  3. Tìm instance có ID khớp với `public_instance_id`, ghi lại **Public IP**.
  4. Mở terminal trên máy tính cá nhân.
  5. Sử dụng lệnh SSH để kết nối đến Public EC2:
     ```bash
     ssh -i ./keypair/lab1-keypair ec2-user@<Public-IP>
     ```
  6. Kiểm tra xem kết nối có thành công hay không.
- **Kết quả mong đợi**:
  - Kết nối SSH thành công, hiển thị terminal của Public EC2.
- **Output mẫu**:
  ```
  Terraform output:
  public_instance_id = "i-1234567890abcdef0"
  public_sg_id = "sg-12345678"

  SSH Output:
  Last login: Mon Apr 22 12:00:00 2025 from 123.45.67.89
  [ec2-user@ip-10-0-1-xxx ~]$
  ```
- **Kết quả kiểm thử**:
  - [ ] Pass: Kết nối SSH thành công từ IP được phép.
  - [ ] Fail: Kết nối bị từ chối hoặc timeout.

### Test Case 3.2: Kiểm tra SSH từ Public EC2 đến Private EC2
- **Mô tả**: Xác minh rằng có thể SSH từ Public EC2 (dựa trên `public_instance_id`) đến Private EC2 (dựa trên `private_instance_id`) thông qua Security Group (`private_sg_id`).
- **Điều kiện tiên quyết**:
  - Terraform đã được áp dụng thành công.
  - Có output `public_instance_id` và `private_instance_id` từ module `compute`, và `private_sg_id` từ module `security`.
  - Đã SSH vào Public EC2 thành công (theo Test Case 3.1).
  - Có địa chỉ IP riêng của Private EC2 (từ AWS Console hoặc Terraform output).
- **Các bước thực hiện**:
  1. Chạy lệnh để xem output của Terraform:
     ```bash
     terraform output public_instance_id
     terraform output private_instance_id
     terraform output private_sg_id
     ```
     Ghi lại giá trị `public_instance_id` (ví dụ: `i-1234567890abcdef0`), `private_instance_id` (ví dụ: `i-0987654321fedcba0`), và `private_sg_id` (ví dụ: `sg-87654321`).
  2. Đăng nhập vào AWS Console, điều hướng đến **EC2** → **Instances**.
  3. Tìm instance có ID khớp với `private_instance_id`, ghi lại **Private IP**.
  4. Từ terminal của Public EC2 (sau khi SSH vào), chạy lệnh:
     ```bash
     ssh ec2-user@<Private-IP>
     ```
  5. Kiểm tra xem kết nối có thành công hay không.
- **Kết quả mong đợi**:
  - Kết nối SSH thành công, hiển thị terminal của Private EC2.
- **Output mẫu**:
  ```
  Terraform output:
  public_instance_id = "i-1234567890abcdef0"
  private_instance_id = "i-0987654321fedcba0"
  private_sg_id = "sg-87654321"

  SSH Output:
  Last login: Mon Apr 22 12:05:00 2025 from 10.0.1.xxx
  [ec2-user@ip-10-0-2-xxx ~]$
  ```
- **Kết quả kiểm thử**:
  - [ ] Pass: Kết nối SSH từ Public EC2 đến Private EC2 thành công.
  - [ ] Fail: Kết nối bị từ chối hoặc timeout.

---

## 4. EC2 Instances

### Test Case 4.1: Kiểm tra Public EC2 có thể truy cập từ Internet
- **Mô tả**: Xác minh rằng Public EC2 (dựa trên `public_instance_id` từ module `compute`) có thể được truy cập từ Internet thông qua SSH.
- **Điều kiện tiên quyết**:
  - Terraform đã được áp dụng thành công.
  - Có output `public_instance_id` từ module `compute`.
  - Đã có tệp khóa SSH (`lab1-keypair`) và địa chỉ IP công khai của Public EC2 (từ AWS Console hoặc Terraform output).
- **Các bước thực hiện**:
  1. Chạy lệnh để xem output của Terraform:
     ```bash
     terraform output public_instance_id
     ```
     Ghi lại giá trị `public_instance_id` (ví dụ: `i-1234567890abcdef0`).
  2. Đăng nhập vào AWS Console, điều hướng đến **EC2** → **Instances**.
  3. Tìm instance có ID khớp với `public_instance_id`, ghi lại **Public IP**.
  4. Mở terminal trên máy tính cá nhân.
  5. Sử dụng lệnh SSH để kết nối đến Public EC2:
     ```bash
     ssh -i ./keypair/lab1-keypair ec2-user@<Public-IP>
     ```
  6. Kiểm tra xem kết nối có thành công hay không.
- **Kết quả mong đợi**:
  - Kết nối SSH thành công, hiển thị terminal của Public EC2.
- **Output mẫu**:
  ```
  Terraform output:
  public_instance_id = "i-1234567890abcdef0"

  SSH Output:
  Last login: Mon Apr 22 12:10:00 2025 from 123.45.67.89
  [ec2-user@ip-10-0-1-xxx ~]$
  ```
- **Kết quả kiểm thử**:
  - [ ] Pass: Public EC2 có thể truy cập từ Internet.
  - [ ] Fail: Kết nối bị từ chối hoặc timeout.

### Test Case 4.2: Kiểm tra Private EC2 có thể ping đến google.com
- **Mô tả**: Xác minh rằng Private EC2 (dựa trên `private_instance_id` từ module `compute`) có kết nối Internet thông qua NAT Gateway bằng cách ping đến `google.com`.
- **Điều kiện tiên quyết**:
  - Terraform đã được áp dụng thành công.
  - Có output `private_instance_id` từ module `compute`.
  - Đã SSH vào Public EC2 và từ đó SSH vào Private EC2 (theo Test Case 3.2).
- **Các bước thực hiện**:
  1. Chạy lệnh để xem output của Terraform:
     ```bash
     terraform output private_instance_id
     ```
     Ghi lại giá trị `private_instance_id` (ví dụ: `i-0987654321fedcba0`).
  2. Đăng nhập vào AWS Console, điều hướng đến **EC2** → **Instances**.
  3. Tìm instance có ID khớp với `private_instance_id`, xác nhận instance đang chạy.
  4. Từ terminal của Private EC2 (sau khi SSH vào từ Public EC2), chạy lệnh:
     ```bash
     ping -c 4 google.com
     ```
  5. Kiểm tra xem có nhận được phản hồi từ `google.com` hay không.
- **Kết quả mong đợi**:
  - Ping thành công, hiển thị các gói tin phản hồi từ `google.com`.
- **Output mẫu**:
  ```
  Terraform output:
  private_instance_id = "i-0987654321fedcba0"

  Ping Output:
  PING google.com (142.250.190.14) 56(84) bytes of data.
  64 bytes from 142.250.190.14: icmp_seq=1 ttl=117 time=23.5 ms
  64 bytes from 142.250.190.14: icmp_seq=2 ttl=117 time=22.8 ms
  64 bytes from 142.250.190.14: icmp_seq=3 ttl=117 time=23.1 ms
  64 bytes from 142.250.190.14: icmp_seq=4 ttl=117 time=22.9 ms
  ```
- **Kết quả kiểm thử**:
  - [ ] Pass: Private EC2 ping thành công đến `google.com`.
  - [ ] Fail: Không nhận được phản hồi hoặc lỗi kết nối.

---

## 5. Dọn Dẹp

### Test Case 5.1: Kiểm tra xóa toàn bộ tài nguyên bằng `terraform destroy`
- **Mô tả**: Xác minh rằng tất cả tài nguyên được tạo bởi Terraform (dựa trên các output từ các module) được xóa sạch khi chạy `terraform destroy`.
- **Điều kiện tiên quyết**:
  - Terraform đã được áp dụng thành công và các tài nguyên đã được tạo.
  - Có quyền chạy lệnh `terraform destroy`.
  - Có tất cả output từ các module (`vpc_id`, `public_subnet_ids`, `private_subnet_ids`, `igw_id`, `nat_gateway_id`, `public_instance_id`, `private_instance_id`, `public_sg_id`, `private_sg_id`, `default`).
- **Các bước thực hiện**:
  1. Chạy lệnh để xem tất cả output của Terraform:
     ```bash
     terraform output
     ```
     Ghi lại các giá trị như `vpc_id`, `public_subnet_ids`, `private_subnet_ids`, `igw_id`, `nat_gateway_id`, `public_instance_id`, `private_instance_id`, `public_sg_id`, `private_sg_id`, `default`.
  2. Chạy lệnh:
     ```bash
     terraform destroy
     ```
  3. Nhập `yes` khi được yêu cầu xác nhận.
  4. Sau khi lệnh hoàn tất, đăng nhập vào AWS Console.
  5. Kiểm tra các dịch vụ sau để đảm bảo không còn tài nguyên:
     - **VPC**: Không còn VPC với ID khớp `vpc_id`.
     - **Subnets**: Không còn subnet với ID trong `public_subnet_ids` hoặc `private_subnet_ids`.
     - **EC2**: Không còn instance với ID trong `public_instance_id` hoặc `private_instance_id`.
     - **Security Groups**: Không còn Security Group với ID trong `public_sg_id`, `private_sg_id`, hoặc `default`.
     - **Internet Gateway**: Không còn IGW với ID trong `igw_id`.
     - **NAT Gateway**: Không còn NAT Gateway với ID trong `nat_gateway_id`.
- **Kết quả mong đợi**:
  - Tất cả tài nguyên được tạo bởi Terraform đã bị xóa.
  - AWS Console không hiển thị bất kỳ tài nguyên nào có ID khớp với các output.
- **Output mẫu**:
  ```
  Terraform output (before destroy):
  vpc_id = "vpc-12345678"
  public_subnet_ids = ["subnet-12345678"]
  private_subnet_ids = ["subnet-87654321"]
  igw_id = "igw-abcdefgh"
  nat_gateway_id = "nat-ijklmnop"
  public_instance_id = "i-1234567890abcdef0"
  private_instance_id = "i-0987654321fedcba0"
  public_sg_id = "sg-12345678"
  private_sg_id = "sg-87654321"
  default = "sg-abcdef12"

  Terraform destroy:
  Destroy complete! Resources: 10 destroyed.

  AWS Console:
  No resources found for the specified IDs.
  ```
- **Kết quả kiểm thử**:
  - [ ] Pass: Tất cả tài nguyên đã được xóa sạch.
  - [ ] Fail: Vẫn còn tài nguyên tồn tại sau khi chạy `terraform destroy`.

---

### Lưu Ý
- Các test case trên sử dụng các output từ Terraform để xác minh tài nguyên, giúp đảm bảo tính chính xác và dễ dàng đối chiếu với trạng thái thực tế trên AWS.
- Đảm bảo lưu tệp khóa SSH (`lab1-keypair`) trong thư mục `keypair` và cấu hình đúng `your_ip` trong `terraform.tfvars` trước khi kiểm thử.