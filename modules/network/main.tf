resource "aws_vpc" "vpc_IncaApp" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge(var.tags_comunes, { Name = "vpc_IncaApp" })
}

resource "aws_subnet" "public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.vpc_IncaApp.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags = merge(var.tags_comunes, {
    Name = "public-${each.key}-IncaApp"
  })
}

resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc_IncaApp.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags = merge(var.tags_comunes, {
    Name = "private-${each.key}-IncaApp"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.vpc_IncaApp.id
  tags = merge(var.tags_comunes, {
    Name = "internet_gateway_IncaApp"
  })
}

resource "aws_eip" "eip_IncaApp" {
  count  = var.entorno == "prod" ? 1 : 0
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway_IncaApp" {
  count         = var.entorno == "prod" ? 1 : 0
  subnet_id     = values(aws_subnet.public_subnets)[0].id
  allocation_id = aws_eip.eip_IncaApp[0].id
  depends_on    = [aws_internet_gateway.this]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc_IncaApp.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc_IncaApp.id
}

resource "aws_route" "private" {
  count                  = var.entorno == "prod" ? 1 : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_IncaApp[0].id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}