output "ec2_public_ip" {
  value = aws_instance.app.public_ip
}

output "ec2_sg_id" {
  value = aws_security_group.web.id
}