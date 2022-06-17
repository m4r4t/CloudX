locals {
  vpc_name = join(var.delimiter, [var.vpc_base_name, random_id.this.dec])
  vpc_tags = merge({ Name = local.vpc_name }, var.base_tags)
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags       = local.vpc_tags
}
