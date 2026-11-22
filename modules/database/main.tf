resource "random_password" "contraseña_IncaApp" {
  length = 16
  special = false
}

resource "aws_db_subnet_group" "subnets_db_IncaApp" {
  subnet_ids = var.private_subnet_ids
  name = "db-${var.db_name}-subnet-group"
}

resource "aws_security_group" "sg_db_IncaApp" {
  name = "${var.db_name}-rds-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [ var.allowed_sg_id ]
  }
}

resource "aws_db_instance" "rds_IncaApp" {
  identifier             = "${var.db_name}-db"
  engine                 = "postgres"
  engine_version         = "16.3"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = var.db_name
  username               = var.db_username
  password               = random_password.contraseña_IncaApp.result
  db_subnet_group_name   = aws_db_subnet_group.subnets_db_IncaApp.name
  vpc_security_group_ids = [aws_security_group.sg_db_IncaApp.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  tags = var.tags_comunes
  #Se pondia lifecycle { prevent_destroy = true} para evitar borrar
}