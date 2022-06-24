locals {
  srv1_name   = "linux server"
  srv2_name   = "windows server"
  sg_name     = "pub_access_linux"
  sg_name_win = "pub_access_windows"
}


resource "aws_instance" "srv1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.test_key_pair.id
  vpc_security_group_ids = [aws_security_group.public_access_linux.id]
  #iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  #subnet_id = aws_subnet.vpc1.id

  tags = merge({ Name = local.srv1_name }, var.base_tags)
}




resource "aws_instance" "winsrv1" {
  ami                    = data.aws_ami.windows-2022.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.test_key_pair.id
  vpc_security_group_ids = [aws_security_group.public_access_win.id]

  tags = merge({ Name = local.srv2_name }, var.base_tags)
}