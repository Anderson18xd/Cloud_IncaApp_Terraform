aws_region    = "us-east-1"
environment   = "dev"
vpc_cidr      = "10.0.0.0/16"
ingress_ports = [22, 80]

instance_types = {
  dev  = "t3.micro"
  prod = "t3.small"
}

public_subnets = {
  "pub-a" = { cidr = "10.0.1.0/24", az = "us-east-1a" }
  "pub-b" = { cidr = "10.0.2.0/24", az = "us-east-1b" }
}

private_subnets = {
  "priv-a" = { cidr = "10.0.11.0/24", az = "us-east-1a" }
  "priv-b" = { cidr = "10.0.12.0/24", az = "us-east-1b" }
}