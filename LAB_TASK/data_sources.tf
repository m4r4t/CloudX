data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }


}

data "aws_region" "current" {}

/*
data "aws_ec2_managed_prefix_list" "private_ecr_dkr" {
  name = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  //prefix_list_id = aws_vpc_endpoint.ecr_dkr.prefix_list_id
}

data "aws_ec2_managed_prefix_list" "private_ecr_api" {
  name = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  //prefix_list_id = aws_vpc_endpoint.ecr_api.prefix_list_id
}
*/