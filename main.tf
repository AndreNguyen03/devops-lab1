provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = var.vpc_cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "nat_gateway" {
  source = "./modules/nat_gateway"

  vpc_id = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_ids[0]
}


module "route_table" {
  source = "./modules/route_table"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids = module.vpc.public_subnet_ids
  igw_id = module.vpc.igw_id
  nat_gateway_id = module.nat_gateway.nat_gateway_id
}


resource "aws_key_pair" "lab1-keypair" {
  key_name = "lab1-keypair"
  public_key = file("./keypair/lab1-keypair.pub")
}


module "compute" {
  source            = "./modules/compute"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = aws_key_pair.lab1-keypair.key_name
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  private_subnet_id = module.vpc.private_subnet_ids[0]
  public_sg_id      = module.security.public_sg_id.id
  private_sg_id     = module.security.private_sg_id.id
}

module "security" {
  source = "./modules/security"

  vpc_id         = module.vpc.vpc_id
  allowed_ssh_ip = var.allowed_ssh_ip
}

