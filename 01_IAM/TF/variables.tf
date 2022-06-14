variable "env" {
  type    = string
  default = "CloudX 01"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}


variable "path_to_key" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}
