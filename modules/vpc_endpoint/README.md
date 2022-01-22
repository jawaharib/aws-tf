# Terraform Module For VPC Endpoint

Provides a VPC Endpoint resource.

Following module is a generic module for creating a VPC Endpoint. It creates a single VPC endpoint for a user specified service.

Core Version Constraints: :black_nib:
* `>= 0.12.26`

Provider Requirements: :computer:
* **aws (`hashicorp/aws`):** `>= 3.15`

## Input Variables :electric_plug:
* `app_name` (required): Application name.
* `auto_accept` (default `null`): Accept the VPC endpoint (the VPC endpoint and service need to be in the same AWS account)
* `create` (default `true`): Determines whether resources will be created
* `endpoints` (default `{}`): A map of interface and/or gateway endpoints containing their properties and configurations
* `env` (required): Environment name.
* `policy` (default `null`): A policy to attach to the endpoint that controls access to the service. Defaults to full access.
* `private_dns_enabled` (default `false`): AWS services and AWS Marketplace partner services only) Whether or not to associate a private hosted zone with the specified VPC.
* `route_table_ids` (default `null`): One or more route table IDs. Applicable for endpoints of type Gateway.
* `security_group_ids` (default `[]`): Default security group IDs to associate with the VPC endpoints
* `service` (default `null`): The common name of an AWS service (e.g. s3).
* `service_name` (default `null`): The service name that is specified when creating a VPC endpoint.
* `service_type` (default `"Interface"`): The service type, Gateway or Interface.
* `subnet_ids` (default `[]`): Default subnets IDs to associate with the VPC endpoints
* `tags` (default `{}`): A map of tags to use on all resources
* `timeouts` (default `{}`): Define maximum timeout for creating, updating, and deleting VPC endpoint resources
* `vpc_endpoint_type` (default `"Interface"`): The VPC endpoint type, Gateway, GatewayLoadBalancer, or Interface. Defaults to Gateway
* `vpc_id` (default `""`): The ID of the VPC in which the endpoint will be used

## Output Values  :scroll:
* `endpoints`: Array containing the full resource object and attributes for all endpoints created


## Usage  :wrench:

Assuming, we need to create multiple VPC endpints with this module, you should use the multiple VPC module alongside with this so as to create VPC and its endpoint at same place.

```
module "vpc" {
  source                             = "/path/to/vpc/module"
  for_each                           = var.vpc_settings
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
  source             = "/path/to/vpc_ep/module"
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

################################################################################
# Supporting Resources
################################################################################

data "aws_security_group" "default" {
  for_each = var.vpc_settings
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

data "aws_iam_policy_document" "dynamodb_endpoint_policy" {
  statement {
    effect    = "Deny"
    actions   = ["dynamodb:*"]
    resources = ["*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "aws:sourceVpce"

      values = [data.aws_vpc_endpoint_service.dynamodb.id]
    }
  }
}

data "aws_iam_policy_document" "generic_endpoint_policy" {
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "aws:sourceVpce"

      values = [data.aws_vpc_endpoint_service.dynamodb.id]
    }
  }
}

```


## How terraform.tfvars would look like ? :book:

terraform.tfvars is used just for VPC Variables. VPC Endpoint variables are specified in locals block.

```
vpc_settings = {
  my_vpc = {
    cidr                               = "10.169.0.0/16"
    public_subnets                     = ["10.169.0.0/21", "10.169.8.0/21"]
    private_subnets                    = ["10.169.32.0/21", "10.169.40.0/21"]
    database_subnets                   = ["10.169.96.0/24", "10.169.97.0/24"]
    azs                                = ["ap-southeast-1a", "ap-southeast-1b"]
    manage_default_route_table         = true
    create_database_subnet_route_table = true
    create_database_subnet_group       = false
    public_subnet_tags = {
      "subnet_type" = "public"
    }
    private_subnet_tags = {
      "subnet_type" = "private"
    }
    database_subnet_tags = {
      "subnet_type" = "database"
    }
}
```


## How locals.tf would look like ? :book:
Assuming you need to create 2 VPC Endpoints, one for S3 and another one for DynamoDB, usage would look like following.
Note that VPC mapping of a particular endpoint is done via vpc_index parameter. This is the the logical name of vpc which we have used while speciying VPC variables.

```

locals {
  vpc_id         = module.vpc["my_vpc"].vpc_id
  public_subnets = module.vpc["my_vpc"].public_subnets
  endpoints = {
    s3_my_vpc = {
      service   = "s3"
      vpc_index = "my_vpc"
      tags = {
        Name = "s3-vpc-endpoint"
      }
    },
    dynamodb_my_vpc = {
      service      = "dynamodb"
      vpc_index    = "my_vpc"
      service_type = "Gateway"
      policy       = data.aws_iam_policy_document.dynamodb_endpoint_policy.json
      tags = {
        Name = "dynamodb-vpc-endpoint"
      }
    }
  }
}

```




## Contributing  :open_hands:
Pull requests are welcome. :blush:

For major changes, please open an issue first to discuss what you would like to change. :wink:




## Contributors

[@Chirag Sharma](https://bitbucket.org/chirag-cldcvr/)
