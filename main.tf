provider "aws" {
  region = var.region
}
resource "aws_key_pair" "lab1-keypair" {
  key_name = "lab1-keypair"
  public_key = file("./keypair/lab1-keypair.pub")
}

module "network" {
  source               = "./modules/network"
  cidr_block           = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}


module "security" {
  source  = "./modules/security"
  vpc_id  = module.network.vpc_id
  your_ip = var.your_ip
}   

module "compute" {
  source            = "./modules/compute"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = aws_key_pair.lab1-keypair.key_name
  public_subnet_id  = module.network.public_subnet_ids[0]
  private_subnet_id = module.network.private_subnet_ids[0]
  public_sg_id      = module.security.public_sg_id
  private_sg_id     = module.security.private_sg_id
}
