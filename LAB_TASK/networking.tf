locals {
  vpc_cidr              = var.vpc_cidr
  vpc_tag_name          = var.vpc_tag_name
  zone_names            = data.aws_availability_zones.available.names
  pub_subnet_count      = length(local.zone_names)
  priv_db_subnet_count  = length(local.zone_names)
  priv_db_subnetd_cidrs = ["10.10.20.0/24", "10.10.21.0/24", "10.10.22.0/24"]
  subnet_length         = var.subnet_length
  igw1_name             = "cloudx-igw"
  rt1_name              = "public_rt"
}

resource "aws_vpc" "lab1" {
  cidr_block           = local.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge({ Name = local.vpc_tag_name }, var.base_tags)
}

resource "aws_internet_gateway" "gw1" {
  vpc_id = aws_vpc.lab1.id

  tags = merge({ Name = local.igw1_name }, var.base_tags)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab1.id
  tags   = merge({ Name = local.rt1_name }, var.base_tags)
}

resource "aws_route" "def_vpc_lab1" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw1.id
}

resource "aws_subnet" "public" {
  count                   = local.pub_subnet_count
  vpc_id                  = aws_vpc.lab1.id
  map_public_ip_on_launch = true
  availability_zone       = local.zone_names[count.index]
  cidr_block              = cidrsubnet(local.vpc_cidr, local.subnet_length, count.index)

  tags = merge({ Name = "Public - ${local.zone_names[count.index]}" }, var.base_tags)
}

resource "aws_route_table_association" "rt" {
  count          = local.pub_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private_db" {
  count                   = local.priv_db_subnet_count
  vpc_id                  = aws_vpc.lab1.id
  map_public_ip_on_launch = false
  availability_zone       = local.zone_names[count.index]
  cidr_block              = element(local.priv_db_subnetd_cidrs, count.index)

  tags = merge({ Name = "private_db_${local.zone_names[count.index]}" }, var.base_tags)
}