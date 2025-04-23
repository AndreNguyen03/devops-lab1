resource "aws_security_group" "default_vpc" {
  name = "default-vpc-sg"
  description = "Default VPC security group"
  vpc_id = var.vpc_id
  
  tags = {
    Name = "default-vpc-sg"
  }
}