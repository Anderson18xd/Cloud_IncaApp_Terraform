output "contraseña_IncaApp" {
  value     = random_password.contraseña_IncaApp
  sensitive = true
}

output "db_endpoint" {
  value = aws_db_instance.rds_IncaApp.endpoint
}