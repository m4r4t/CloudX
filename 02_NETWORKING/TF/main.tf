module "vpc1" {
  source = "./modules/vpc"

  vpc_cidr      = "10.0.0.0/16"
  base_tags     = var.base_tags
  vpc_base_name = "VPC1"
}


module "vpc2" {
  source = "./modules/vpc"

  vpc_cidr      = "10.1.0.0/16"
  base_tags     = var.base_tags
  vpc_base_name = "VPC2"
}