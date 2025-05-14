variable "ami_id" {
  type        = string
  description = "The AMI ID to use for launching EC2 instances"
}


variable "instance_type" {
  type        = string
  description = "The instance type to use for EC2 (e.g., t2.micro)"
}




variable "public_subnet_id" {
  type        = string
  description = "The ID of the public subnet for the public EC2 instance"
}


variable "private_subnet_id" {
  type        = string
  description = "The ID of the private subnet for the private EC2 instance"
}


variable "public_sg_id" {
  type        = string
  description = "The ID of the security group for the public EC2 instance"
}


variable "private_sg_id" {
  type        = string
  description = "The ID of the security group for the private EC2 instance"
}

variable "restricted_sg_id" {
  type        = string
  description = "The ID of the restricted security group for the instance"
}

variable "key_name" {
  type        = string
  description = "Keyname for the EC2 instances"
}
