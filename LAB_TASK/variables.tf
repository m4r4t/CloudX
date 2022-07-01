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

variable "vpc_tag_name" {
  type    = string
  default = "cloudx"
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "subnet_length" {
  type    = number
  default = 8
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "path_to_key" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "http_port" {
  type    = number
  default = 80
}

variable "my_ip" {
  type = string
}