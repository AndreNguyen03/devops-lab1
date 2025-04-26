output "vpc_id" {
  value = aws_vpc.main-vpc.id
}
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
output "igw_id" {
  value = aws_internet_gateway.main-igw.id
}
