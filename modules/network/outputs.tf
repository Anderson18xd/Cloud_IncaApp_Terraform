output "vpc_id" {
  value = aws_vpc.vpc_IncaApp.id
}

output "public_subnet_ids" {
  value = {
    for k , s in aws_subnet.public_subnets: k => s.id 
  }
}

output "private_subnet_ids" {
  value = values(aws_subnet.private_subnets)[*].id
}