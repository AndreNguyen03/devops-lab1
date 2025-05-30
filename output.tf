output "vpc_id" {
  value = module.vpc.vpc_id
}


output "public_instance_ip" {
  value = module.compute.public_instance_ip
}


output "private_instance_ip" {
  value = module.compute.private_instance_ip
}
