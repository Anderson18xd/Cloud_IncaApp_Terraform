variable "aws_region" { type = string }
variable "vpc_cidr" { type = string }
variable "ingress_ports" { type = list(number) }
variable "instance_types" { type = map(string) }

variable "public_subnets" {
  type = map(object({ cidr = string, az = string }))
}

variable "private_subnets" {
  type = map(object({ cidr = string, az = string }))
}

variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "El entorno debe ser 'dev' o 'prod'."
  }
}