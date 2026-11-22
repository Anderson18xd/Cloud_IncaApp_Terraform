variable "environment" { type = string }
variable "vpc_id" { type = string }
variable "subnet_id" { type = string }
variable "instance_profile_name" { type = string }
variable "ingress_ports" { type = list(number) } 
variable "instance_types" { type = map(string) } 
variable "tags_comunes" { type = map(string) }