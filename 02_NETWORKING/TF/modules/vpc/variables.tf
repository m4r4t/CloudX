variable vpc_cidr {
    type = string
}

variable "delimiter" {
  type    = string
  default = "-"
}

variable "base_tags" {
  type = map(any) 
}

variable "vpc_base_name" {
    type = string
}