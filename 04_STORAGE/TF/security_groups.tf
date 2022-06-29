locals {
  sg_name         = "ec2_pub_access"
  sg_tag_name     = "SG for EC2 public access"
  efs_sg_name     = "efs_access"
  efs_sg_tag_name = "SG for EFS access"
  efs_port        = 2049
}


resource "aws_security_group" "public_access_linux" {
  name        = local.sg_name
  description = "allow pub access"
  vpc_id      = data.aws_vpc.default.id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({ Name = local.sg_tag_name }, var.base_tags)
}


resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_access_linux.id
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_access_linux.id
}

resource "aws_security_group_rule" "allow_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_access_linux.id
}


resource "aws_security_group_rule" "allow_icmp_out" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_access_linux.id
}


resource "aws_security_group" "ingress-efs-test" {
  name        = local.efs_sg_name
  description = "allow EFS access"
  vpc_id      = data.aws_vpc.default.id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({ Name = local.efs_sg_tag_name }, var.base_tags)
}

resource "aws_security_group_rule" "allow_efs_ingress" {
  type              = "ingress"
  from_port         = local.efs_port
  to_port           = local.efs_port
  protocol          = "tcp"
  cidr_blocks       = [aws_default_subnet.az1.cidr_block, aws_default_subnet.az2.cidr_block]
  security_group_id = aws_security_group.ingress-efs-test.id
}


resource "aws_security_group_rule" "allow_efs_egress" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = "-1"
  cidr_blocks       = [aws_default_subnet.az1.cidr_block, aws_default_subnet.az2.cidr_block]
  security_group_id = aws_security_group.ingress-efs-test.id
}