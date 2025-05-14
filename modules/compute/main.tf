resource "aws_instance" "public" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.public_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = false
  ebs_optimized               = true
  monitoring = true

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # <-- Bắt buộc dùng IMDSv2
    http_put_response_hop_limit = 1
  }

  tags = {
    Name = "public-ec2-instance"
  }
}


resource "aws_instance" "private" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.private_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = false
  ebs_optimized               = true
  monitoring = true

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # <-- Bắt buộc dùng IMDSv2
    http_put_response_hop_limit = 1
  }

  tags = {
    Name = "private-ec2-instance"
  }
}
