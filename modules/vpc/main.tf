resource "aws_vpc" "main-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "main-vpc"
  }
}

locals {
  public_subnet_name = "public-subnet-${count.index + 1}"
  private_subnet_name = "private-subnet-${count.index + 1}"
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = local.public_subnet_name
  }
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = local.private_subnet_name
  }
}

resource "aws_internet_gateway" "main-igw" {
    vpc_id = aws_vpc.main-vpc.id
    tags = {
      Name = "main-igw"
    }
}

