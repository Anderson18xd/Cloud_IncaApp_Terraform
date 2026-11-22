aws_region    = "us-east-1"
environment   = "prod"
vpc_cidr      = "10.1.0.0/16"
ingress_ports = [22, 80]

instance_types = {
  dev  = "t3.micro"
  prod = "t3.small"
}

public_subnets = {
  "pub-a" = { cidr = "10.1.1.0/24", az = "us-east-1a" }
  "pub-b" = { cidr = "10.1.2.0/24", az = "us-east-1b" }
}

private_subnets = {
  "priv-a" = { cidr = "10.1.11.0/24", az = "us-east-1a" }
  "priv-b" = { cidr = "10.1.12.0/24", az = "us-east-1b" }
}