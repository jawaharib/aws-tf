module "frontend_security_group" {
  source         = "../modules/security_group"
  vpc_id         = module.vpc["vpc1"].vpc_id
  tags           = local.tags
  env            = var.env
  app_name       = var.app_name
  security_group = local.frontend_security_group
}

module "backend_security_group" {
  source         = "../modules/security_group"
  vpc_id         = module.vpc["vpc1"].vpc_id
  tags           = local.tags
  env            = var.env
  app_name       = var.app_name
  security_group = local.backend_security_group
}

module "bastion_security_group" {
  source         = "../modules/security_group"
  vpc_id         = module.vpc["vpc1"].vpc_id
  tags           = local.tags
  env            = var.env
  app_name       = var.app_name
  security_group = local.bastion_security_group
}

module "lambda_security_group" {
  source         = "../modules/security_group"
  vpc_id         = module.vpc["vpc1"].vpc_id
  tags           = local.tags
  env            = var.env
  app_name       = var.app_name
  security_group = local.lambda_security_group
}
