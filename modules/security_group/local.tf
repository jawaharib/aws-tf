locals {
  sg_name = format("%s-%s-%s-sg", var.app_name, var.env, var.security_group["name"])
}
