locals {
  srv1_name = "Bastion"
}


resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.lab_key_pair.id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  #user_data              = base64encode(templatefile("user-data-http.sh", { http_port = var.http_port }))
  #iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  subnet_id = aws_subnet.public[0].id

  tags = merge({ Name = local.srv1_name }, var.base_tags)
}

