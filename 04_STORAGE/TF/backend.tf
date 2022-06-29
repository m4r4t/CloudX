terraform {
  backend "s3" {
    bucket  = "tfstate-8015"
    key     = "CloudX/04_storage/0/terraform.tfstate"
    region  = "eu-west-1"
    profile = "gmail"

    dynamodb_table = "tf-locks"
    encrypt        = "true"
  }
}