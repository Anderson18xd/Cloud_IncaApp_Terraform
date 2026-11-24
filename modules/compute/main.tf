data "aws_ami" "id_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

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
  tags                   = merge(var.tags_comunes, { Name = "app-ec2-${var.environment}" })
  lifecycle {
    ignore_changes = [ami]
  }
}