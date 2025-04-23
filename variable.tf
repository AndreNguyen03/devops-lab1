variable "region" {
  type        = string
  description = "The aws region where all resources will be deployed"
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC (e.g., 10.0.0.0/16)"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
}