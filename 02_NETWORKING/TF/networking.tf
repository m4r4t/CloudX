locals {
  vpc1_cidr      = "172.20.0.0/16"
  vpc1_base_name = "VPC-1"
  vpc2_cidr      = "172.21.0.0/16"
  vpc2_base_name = "VPC-2"
  vpc3_cidr      = "172.22.0.0/16"
  vpc3_base_name = "VPC-3"

  vpc1_vpc2_pxc_name = "vpc1 vpc2"
  vpc2_vpc3_pxc_name = "vpc2 vpc3"

  igw1_name = "IGW1"
  igw2_name = "IGW2"
  igw3_name = "IGW3"

  tgw_name = "TGW_TEST"

  rt1_name = "VPC1 public RT"
  rt2_name = "VPC2 public RT"
  rt3_name = "VPC3 public RT"

  subnet_vpc1_name = "vpc1 public subnet"
  subnet_vpc2_name = "vpc2 public subnet"
  subnet_vpc3_name = "vpc3 public subnet"
  subnet_vpc1_cidr = cidrsubnet(local.vpc1_cidr, 8, 0)
  subnet_vpc2_cidr = cidrsubnet(local.vpc2_cidr, 8, 0)
  subnet_vpc3_cidr = cidrsubnet(local.vpc3_cidr, 8, 0)
  subnet_vpc1_az   = "eu-west-1a"
  subnet_vpc2_az   = "eu-west-1b"
  subnet_vpc3_az   = "eu-west-1c"
}

#------------------------------------------------------------------------------
#   VPC
#------------------------------------------------------------------------------
module "vpc1" {
  source = "./modules/vpc"

  vpc_cidr      = local.vpc1_cidr
  base_tags     = var.base_tags
  vpc_base_name = local.vpc1_base_name
}

module "vpc2" {
  source = "./modules/vpc"

  vpc_cidr      = local.vpc2_cidr
  base_tags     = var.base_tags
  vpc_base_name = local.vpc2_base_name
}

module "vpc3" {
  source = "./modules/vpc"

  vpc_cidr      = local.vpc3_cidr
  base_tags     = var.base_tags
  vpc_base_name = local.vpc3_base_name
}


#------------------------------------------------------------------------------
#   IGW
#------------------------------------------------------------------------------
resource "aws_internet_gateway" "gw1" {
  vpc_id = module.vpc1.vpc_id

  tags = merge({ Name = local.igw1_name }, var.base_tags)
}

resource "aws_internet_gateway" "gw2" {
  vpc_id = module.vpc2.vpc_id

  tags = merge({ Name = local.igw2_name }, var.base_tags)
}

resource "aws_internet_gateway" "gw3" {
  vpc_id = module.vpc3.vpc_id

  tags = merge({ Name = local.igw3_name }, var.base_tags)
}



#------------------------------------------------------------------------------
#   Subnets
#------------------------------------------------------------------------------
resource "aws_subnet" "vpc1" {
  vpc_id                  = module.vpc1.vpc_id
  cidr_block              = local.subnet_vpc1_cidr
  availability_zone       = local.subnet_vpc1_az
  map_public_ip_on_launch = true

  tags = merge({ Name = local.subnet_vpc1_name }, var.base_tags)
}

resource "aws_subnet" "vpc2" {
  vpc_id                  = module.vpc2.vpc_id
  cidr_block              = local.subnet_vpc2_cidr
  availability_zone       = local.subnet_vpc2_az
  map_public_ip_on_launch = true

  tags = merge({ Name = local.subnet_vpc2_name }, var.base_tags)
}

resource "aws_subnet" "vpc3" {
  vpc_id                  = module.vpc3.vpc_id
  cidr_block              = local.subnet_vpc3_cidr
  availability_zone       = local.subnet_vpc3_az
  map_public_ip_on_launch = true

  tags = merge({ Name = local.subnet_vpc3_name }, var.base_tags)
}


#------------------------------------------------------------------------------
#   RTs
#------------------------------------------------------------------------------
resource "aws_route_table" "public_rt_vpc1" {
  vpc_id = module.vpc1.vpc_id
  tags   = merge({ Name = local.rt1_name }, var.base_tags)
}

resource "aws_route" "def_vpc1" {
  route_table_id         = aws_route_table.public_rt_vpc1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw1.id
}

resource "aws_route_table" "public_rt_vpc2" {
  vpc_id = module.vpc2.vpc_id
  tags   = merge({ Name = local.rt2_name }, var.base_tags)
}

resource "aws_route" "def_vpc2" {
  route_table_id         = aws_route_table.public_rt_vpc2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw2.id
}


resource "aws_route_table" "public_rt_vpc3" {
  vpc_id = module.vpc3.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw3.id
  }
  tags = merge({ Name = local.rt3_name }, var.base_tags)
}

resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.vpc1.id
  route_table_id = aws_route_table.public_rt_vpc1.id
}

resource "aws_route_table_association" "rt2" {
  subnet_id      = aws_subnet.vpc2.id
  route_table_id = aws_route_table.public_rt_vpc2.id
}

resource "aws_route_table_association" "rt3" {
  subnet_id      = aws_subnet.vpc3.id
  route_table_id = aws_route_table.public_rt_vpc3.id
}


#------------------------------------------------------------------------------
# Transit GateWay   
#------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway" "test" {
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = merge({ Name = local.tgw_name }, var.base_tags)

}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc1" {
  subnet_ids         = [aws_subnet.vpc1.id]
  transit_gateway_id = aws_ec2_transit_gateway.test.id
  vpc_id             = module.vpc1.vpc_id

  tags = merge({ Name = "to vpc1" }, var.base_tags)
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc2" {
  subnet_ids         = [aws_subnet.vpc2.id]
  transit_gateway_id = aws_ec2_transit_gateway.test.id
  vpc_id             = module.vpc2.vpc_id

  tags = merge({ Name = "to vpc2" }, var.base_tags)
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc3" {
  subnet_ids         = [aws_subnet.vpc3.id]
  transit_gateway_id = aws_ec2_transit_gateway.test.id
  vpc_id             = module.vpc3.vpc_id

  tags = merge({ Name = "to vpc3" }, var.base_tags)
}

resource "aws_route" "vpc1_vpc2" {
  route_table_id         = aws_route_table.public_rt_vpc1.id
  destination_cidr_block = local.vpc2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.test.id
}

resource "aws_route" "vpc1_vpc3" {
  route_table_id         = aws_route_table.public_rt_vpc1.id
  destination_cidr_block = local.vpc3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.test.id
}

resource "aws_route" "vpc2_vpc1" {
  route_table_id         = aws_route_table.public_rt_vpc2.id
  destination_cidr_block = local.vpc1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.test.id
}

resource "aws_route" "vpc2_vpc3" {
  route_table_id         = aws_route_table.public_rt_vpc2.id
  destination_cidr_block = local.vpc3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.test.id
}

resource "aws_route" "vpc3_vpc1" {
  route_table_id         = aws_route_table.public_rt_vpc3.id
  destination_cidr_block = local.vpc1_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.test.id
}

resource "aws_route" "vpc3_vpc2" {
  route_table_id         = aws_route_table.public_rt_vpc3.id
  destination_cidr_block = local.vpc2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.test.id
}