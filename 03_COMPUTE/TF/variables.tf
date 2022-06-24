variable "base_tags" {
  type = map(any)
  default = {
    "App"       = "CloudX"
    "Env"       = "Test"
    "CreatedBy" = "TF"
    "Owner"     = "MN"
  }
}

variable "delimiter" {
  type    = string
  default = "-"
}

variable "vpc_base_name" {
  type    = string
  default = "VPC"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "path_to_key" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}