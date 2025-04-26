output "vpc_id" {
  value = module.network.vpc_id
}


output "public_instance_id" {
  value = module.compute.public_instance_id
}


output "private_instance_id" {
  value = module.compute.private_instance_id
}
