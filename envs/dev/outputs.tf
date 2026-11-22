output "app_ip" {
  value = module.compute.ec2_public_ip
}

output "rds_endpoint" {
  value = module.database.db_endpoint
}