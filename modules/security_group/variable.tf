variable "security_group" {
  default = {}
}

variable "vpc_id" {
  description = "VPC Id where subnet is to be created."
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "app_name" {}

variable "env" {}
