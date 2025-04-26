variable "region" {
  type = string
  default     = "ap-southeast-1"
  description = "The AWS region where all resources will be deployed (e.g., ap-southeast-1 for Singapore)"
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


variable "your_ip" {
  type        = string
  description = "Your public IP address in CIDR format (e.g., 123.45.67.89/32) for SSH access"
}


variable "ami_id" {
  type        = string
  description = "The AMI ID to use for launching EC2 instances"
}


variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The instance type for EC2 (e.g., t2.micro)"
}
