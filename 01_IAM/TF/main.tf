terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"

    }
  }
  required_version = ">= 1.2.0"
}

resource "aws_instance" "srv1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.test_key_pair.id
  vpc_security_group_ids = [aws_security_group.test_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "prod instance"
    Env  = "prod"
  }
}

resource "aws_instance" "srv2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.test_key_pair.id
  vpc_security_group_ids = [aws_security_group.test_sg.id]

  tags = {
    Name = "dev instance"
    Env  = "dev"
  }
}