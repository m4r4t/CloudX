/*
resource "random_string" "this" {
  length           = 8
  special          = true
  override_special = "/@£$"
}
*/


resource "random_id" "this" {
  byte_length = 1
  /*keepers = {
    # Generate a new id each time we switch to a new AMI id
    vpc_name = var.vpc_base_name
  } */
}
