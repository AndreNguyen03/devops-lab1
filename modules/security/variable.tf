variable "vpc_id" {
  type = string
  description = "The id of the VPC where the security groups will be created"
}

variable "allowed_ssh_ip" {
  type        = string
  description = "Your public IP address in CIDR format to allow SSH access to public EC2 instance"
}


