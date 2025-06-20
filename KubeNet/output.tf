output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.cluster-net.id
}
output "internet_gateway_id" {
  description = "The Internet Gateway ID"
  value       = aws_internet_gateway.cluster-igw.id
}

output "public_subnet_1" {
  value = aws_subnet.pubsub-1.id
}

output "public_subnet_2" {
  value = aws_subnet.pubsub-2.id
}

output "private_subnet_1" {
  value = aws_subnet.privsub-1.id
}
output "private_subnet_2" {
  value = aws_subnet.privsub-2.id
}
