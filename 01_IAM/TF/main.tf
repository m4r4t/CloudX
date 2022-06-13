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
  ami           = data.aws_ami.ubuntu.id
  instance_type = "${var.instance_type}"

  tags = {
      Name = "prod instance"
      Env = "prod"
  }
}

resource "aws_instance" "srv2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "${var.instance_type}"

  tags = {
      Name = "dev instance"
      Env = "dev"
  }
}