module "vpc" {
  source                             = "../modules/vpc"
  for_each                           = local.vpc_settings
  name                               = lookup(each.value, "name", null)
  cidr                               = lookup(each.value, "cidr", null)
  public_subnets                     = lookup(each.value, "public_subnets", null)
  private_subnets                    = lookup(each.value, "private_subnets", null)
  database_subnets                   = lookup(each.value, "database_subnets", null)
  azs                                = lookup(each.value, "azs", null)
  private_subnet_tags                = lookup(each.value, "private_subnet_tags", {})
  public_subnet_tags                 = lookup(each.value, "public_subnet_tags", {})
  database_subnet_tags               = lookup(each.value, "database_subnet_tags", {})
  vpc_tags                           = lookup(each.value, "vpc_tags", null)
  single_nat_gateway                 = lookup(each.value, "single_nat_gateway", true)
  enable_nat_gateway                 = lookup(each.value, "enable_nat_gateway", true)
  create_database_subnet_route_table = lookup(each.value, "create_database_subnet_route_table", false)
  create_database_subnet_group       = lookup(each.value, "create_database_subnet_group", true)
  manage_default_route_table         = lookup(each.value, "manage_default_route_table", false)
  private_dedicated_network_acl      = lookup(each.value, "private_dedicated_network_acl", false)
  private_inbound_acl_rules          = lookup(each.value, "private_inbound_acl_rules", [])
  database_dedicated_network_acl     = lookup(each.value, "database_dedicated_network_acl", false)
  database_inbound_acl_rules         = lookup(each.value, "database_inbound_acl_rules", [])
  tags                               = local.tags
  env                                = var.env
  app_name                           = var.app_name
  enable_dns_hostnames               = true
  enable_dns_support                 = true
}

################################################################################
# VPC Endpoints Module
################################################################################


module "vpc_endpoints" {
  source             = "../modules/vpc_endpoint"
  for_each           = local.endpoints
  vpc_id             = module.vpc[each.value["vpc_index"]].vpc_id
  security_group_ids = lookup(each.value, "service_type", "Interface") == "Interface" ? distinct(concat(var.extra_security_group_ids, [data.aws_security_group.default[each.value["vpc_index"]].id])) : null
  vpc_endpoint_type  = lookup(each.value, "service_type", "Interface")
  auto_accept        = lookup(each.value, "auto_accept", null)
  env                = var.env
  app_name           = var.app_name

  subnet_ids          = lookup(each.value, "service_type", "Interface") == "Interface" ? distinct(lookup(each.value, "subnet_ids", [])) : null
  route_table_ids     = lookup(each.value, "service_type", "Interface") == "Gateway" ? lookup(each.value, "route_table_ids", null) : null
  policy              = lookup(each.value, "policy", null)
  private_dns_enabled = lookup(each.value, "service_type", "Interface") == "Interface" ? lookup(each.value, "private_dns_enabled", null) : null

  tags = merge(local.tags, {
    Project  = "Secret"
    Endpoint = "true"
  })

  service_name = lookup(each.value, "service_name", null)
  service_type = lookup(each.value, "service_type", "Interface")
  service      = lookup(each.value, "service", null)
}

//module "vpc_endpoints_nocreate" {
//  source = "../../module/vpc_endpoint"
//
//  create = false
//}
################################################################################
# Supporting Resources
################################################################################

data "aws_security_group" "default" {
  //  count = length(local.vpc_settings)
  for_each = local.vpc_settings
  name     = "default"
  vpc_id   = module.vpc[each.key].vpc_id
}

# Data source used to avoid race condition
data "aws_vpc_endpoint_service" "dynamodb" {
  service = "dynamodb"

  filter {
    name   = "service-type"
    values = ["Gateway"]
  }
}

//data "aws_iam_policy_document" "dynamodb_endpoint_policy" {
//  statement {
//    effect    = "Deny"
//    actions   = ["dynamodb:*"]
//    resources = ["*"]
//
//    principals {
//      type        = "*"
//      identifiers = ["*"]
//    }
//
//    condition {
//      test     = "StringNotEquals"
//      variable = "aws:sourceVpce"
//
//      values = [data.aws_vpc_endpoint_service.dynamodb.id]
//    }
//  }
//}
//
//data "aws_iam_policy_document" "generic_endpoint_policy" {
//  statement {
//    effect    = "Deny"
//    actions   = ["*"]
//    resources = ["*"]
//
//    principals {
//      type        = "*"
//      identifiers = ["*"]
//    }
//
//    condition {
//      test     = "StringNotEquals"
//      variable = "aws:sourceVpce"
//
//      values = [data.aws_vpc_endpoint_service.dynamodb.id]
//    }
//  }
//}
