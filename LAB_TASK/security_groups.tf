locals {
  sg1_name        = "bastion"
  sg2_name        = "ec2_pool"
  sg3_name        = "alb"
  sg4_name        = "efs"
  db_sg_name      = "mysql"
  efs_sg_name     = "efs_access"
  efs_sg_tag_name = "SG for EFS access"
  ecs_sg_name     = "ECS access"
  efs_port        = 2049
  db_port         = 3306
}

//-------------------------------------------------------------
resource "aws_security_group" "bastion" {
  name        = local.sg1_name
  description = "access to bastion"
  vpc_id      = aws_vpc.lab1.id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({ Name = local.sg1_name }, var.base_tags)
}


resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

//-------------------------------------------------------------
resource "aws_security_group" "ec2_pool" {
  name        = local.sg2_name
  description = "allows access to ec2 instances"
  vpc_id      = aws_vpc.lab1.id

  tags = merge({ Name = local.sg2_name }, var.base_tags)
}

resource "aws_security_group_rule" "ec2_pool_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = aws_security_group.ec2_pool.id
}

resource "aws_security_group_rule" "ec2_pool_efs" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = aws_security_group.ec2_pool.id
}

resource "aws_security_group_rule" "allow_ghost" {
  type                     = "ingress"
  from_port                = 2368
  to_port                  = 2368
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.ec2_pool.id
}

resource "aws_security_group_rule" "ec2_pool_egress_all" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_pool.id
}

//-------------------------------------------------------------
resource "aws_security_group" "alb" {
  name        = local.sg3_name
  description = "allows access to alb"
  vpc_id      = aws_vpc.lab1.id

  tags = merge({ Name = local.sg3_name }, var.base_tags)
}


resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_allow_all" {
  type                     = "egress"
  from_port                = -1
  to_port                  = -1
  protocol                 = -1
  source_security_group_id = aws_security_group.ec2_pool.id
  security_group_id        = aws_security_group.alb.id
}


//-------------------------------------------------------------
resource "aws_security_group" "efs" {
  name        = local.sg4_name
  description = "defines access to efs mount points"
  vpc_id      = aws_vpc.lab1.id

  tags = merge({ Name = local.sg4_name }, var.base_tags)
}

resource "aws_security_group_rule" "allow_efs_ingress" {
  type                     = "ingress"
  from_port                = local.efs_port
  to_port                  = local.efs_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2_pool.id
  security_group_id        = aws_security_group.efs.id
}

resource "aws_security_group_rule" "from_ecs" {
  type                     = "ingress"
  from_port                = local.efs_port
  to_port                  = local.efs_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.fargate_pool.id
  security_group_id        = aws_security_group.efs.id
}

resource "aws_security_group_rule" "efs_egress_all" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = -1
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = aws_security_group.efs.id
}



//-------------------------------------------------------------
resource "aws_security_group" "mysql" {
  name        = local.db_sg_name
  description = "access to mysql"
  vpc_id      = aws_vpc.lab1.id

  //lifecycle {
  //  create_before_destroy = true
  //}

  tags = merge({ Name = local.db_sg_name }, var.base_tags)
}

resource "aws_security_group_rule" "access_to_mysql" {
  type                     = "ingress"
  from_port                = local.db_port
  to_port                  = local.db_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2_pool.id
  security_group_id        = aws_security_group.mysql.id
}

resource "aws_security_group_rule" "ecs2mysql" {
  type                     = "ingress"
  from_port                = local.db_port
  to_port                  = local.db_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.fargate_pool.id
  security_group_id        = aws_security_group.mysql.id
}

//------------------------------------------------------------------
resource "aws_security_group" "fargate_pool" {
  name        = local.ecs_sg_name
  description = "Allows access for Fargate instances"
  vpc_id      = aws_vpc.lab1.id

  tags = merge({ Name = local.ecs_sg_name }, var.base_tags)
}

resource "aws_security_group_rule" "ecs_allow_efs" {
  type      = "ingress"
  from_port = local.efs_port
  to_port   = local.efs_port
  protocol  = "tcp"
  //source_security_group_id = aws_security_group.efs.id
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = aws_security_group.fargate_pool.id
}

resource "aws_security_group_rule" "ecs_allow_alb" {
  type                     = "ingress"
  from_port                = local.app_port
  to_port                  = local.app_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.fargate_pool.id
}

resource "aws_security_group_rule" "ecs_allow_ec2" {
  type                     = "ingress"
  from_port                = local.app_port
  to_port                  = local.app_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2_pool.id
  security_group_id        = aws_security_group.fargate_pool.id
}

resource "aws_security_group_rule" "ecs_allow_2368" {
  type              = "ingress"
  from_port         = 2368
  to_port           = 2368
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.fargate_pool.id
}

resource "aws_security_group_rule" "ecs_egress" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.fargate_pool.id
}

resource "aws_security_group" "vpce" {
  name   = "For vpcendpoints"
  vpc_id = aws_vpc.lab1.id
}

resource "aws_security_group_rule" "ecs_vpce" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.fargate_pool.id
  security_group_id        = aws_security_group.vpce.id
}
