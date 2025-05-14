output "public_sg_id" {
  value = aws_security_group.public_ec2_sg.id
}


output "private_sg_id" {
  value = aws_security_group.private_ec2_sg.id
}

output "restricted_sg_id" {
  value = aws_security_group.restricted_sg.id
}
