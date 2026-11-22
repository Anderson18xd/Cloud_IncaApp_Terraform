variable "vpc_cidr" {
  type = string
}

variable "entorno" {
  type = string
}

variable "tags_comunes" {
  type = map(string)
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}
