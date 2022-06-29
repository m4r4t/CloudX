locals {
  srv1_name = "Test linux 1"
  srv2_name = "Test linux 2"
}


resource "aws_instance" "srv1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.test_key_pair.id
  vpc_security_group_ids = [aws_security_group.public_access_linux.id]
  user_data              = base64encode(templatefile("user-data-http.sh", { http_port = var.http_port }))
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  subnet_id              = aws_default_subnet.az1.id

  tags = merge({ Name = local.srv1_name }, var.base_tags)
}

resource "aws_instance" "srv2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.test_key_pair.id
  vpc_security_group_ids = [aws_security_group.public_access_linux.id]
  user_data              = base64encode(templatefile("user-data-http.sh", { http_port = var.http_port }))
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  subnet_id              = aws_default_subnet.az2.id


  tags = merge({ Name = local.srv2_name }, var.base_tags)
}