locals {
  sg_name_pub_access_vpc1 = "allow_pub_access_vpc1"
  sg_name_pub_access_vpc2 = "allow_pub_access_vpc2"
  sg_name_pub_access_vpc3 = "allow_pub_access_vpc3"
}


resource "aws_security_group" "public_access_vpc1" {
  name        = local.sg_name_pub_access_vpc1
  description = "Allow necessary inbound traffic"
  vpc_id      = module.vpc1.vpc_id
}

resource "aws_security_group_rule" "allow_ssh_vpc1" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_access_vpc1.id
}

resource "aws_security_group_rule" "allow_icmp_vpc1_in" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_access_vpc1.id
}

resource "aws_security_group_rule" "allow_icmp_vpc1_out" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_access_vpc1.id
}



resource "aws_security_group" "public_access_vpc2" {
  name        = local.sg_name_pub_access_vpc2
  description = "Allow necessary inbound traffic"
  vpc_id      = module.vpc2.vpc_id
}

resource "aws_security_group_rule" "allow_ssh_vpc2" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_access_vpc2.id
}

resource "aws_security_group_rule" "allow_icmp_vpc2" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_access_vpc2.id
}

resource "aws_security_group_rule" "allow_icmp_vpc2_out" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_access_vpc2.id
}

resource "aws_security_group" "public_access_vpc3" {
  name        = local.sg_name_pub_access_vpc3
  description = "Allow necessary inbound traffic"
  vpc_id      = module.vpc3.vpc_id
}

resource "aws_security_group_rule" "allow_ssh_vpc3" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_access_vpc3.id
}

resource "aws_security_group_rule" "allow_icmp_vpc3" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_access_vpc3.id
}

resource "aws_security_group_rule" "allow_icmp_vpc3_out" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_access_vpc3.id
}