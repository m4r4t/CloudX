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
