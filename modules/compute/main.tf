data "aws_ami" "id_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# trivy:ignore:AVD-AWS-0104 (EC2 requiere salida a internet para instalar paquetes)
# trivy:ignore:AVD-AWS-0107 (Servidor web publico requiere trafico entrante en puertos configurados)
resource "aws_security_group" "web" {
  name   = "web-sg-${var.environment}"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.id_ami.id
  instance_type          = lookup(var.instance_types, var.environment, "t3.micro")
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web.id]
  iam_instance_profile   = var.instance_profile_name
  user_data              = file("${path.module}/user_data.sh")

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = merge(var.tags_comunes, { Name = "app-ec2-${var.environment}" })

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_alta" {
  alarm_name          = "cpu-alta-ec2-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120 # Evalúa cada 2 minutos
  statistic           = "Average"
  threshold           = 80  # Dispara si el promedio supera el 80%
  alarm_description   = "Alerta cuando el CPU de la instancia EC2 supera el 80%"

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  tags = var.tags_comunes
}