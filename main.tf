provider "aws" {
  region = var.region
}

module "network" {
  source               = "./modules/network"
  cidr_block         = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}
