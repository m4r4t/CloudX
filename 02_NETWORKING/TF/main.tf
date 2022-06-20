locals {
  srv1_name = "vpc1 server"
  srv2_name = "vpc2 server"
  srv3_name = "vpc3 server"
}


resource "aws_instance" "srv1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.test_key_pair.id
  vpc_security_group_ids = [aws_security_group.public_access_vpc1.id]
  #iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  subnet_id = aws_subnet.vpc1.id

  tags = merge({ Name = local.srv1_name }, var.base_tags)
}

resource "aws_instance" "srv2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.test_key_pair.id
  vpc_security_group_ids = [aws_security_group.public_access_vpc2.id]
  subnet_id              = aws_subnet.vpc2.id

  tags = merge({ Name = local.srv2_name }, var.base_tags)
}

resource "aws_instance" "srv3" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.test_key_pair.id
  vpc_security_group_ids = [aws_security_group.public_access_vpc3.id]
  subnet_id              = aws_subnet.vpc3.id

  tags = merge({ Name = local.srv3_name }, var.base_tags)
}