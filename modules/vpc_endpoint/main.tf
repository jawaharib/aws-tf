################################################################################
# Endpoint(s)
################################################################################

data "aws_vpc_endpoint_service" "this" {
  service      = var.service
  service_name = var.service_name

  filter {
    name   = "service-type"
    values = [var.service_type]
  }
}

resource "aws_vpc_endpoint" "this" {
  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.this.service_name
  vpc_endpoint_type = var.vpc_endpoint_type
  auto_accept       = var.auto_accept

  security_group_ids  = var.security_group_ids
  subnet_ids          = var.subnet_ids
  route_table_ids     = var.route_table_ids
  policy              = var.policy
  private_dns_enabled = var.private_dns_enabled

  tags = merge(
    {
      "Name" = format("%s-%s-%s", var.app_name, var.env, var.service)
    },
    var.tags
  )

  timeouts {
    create = lookup(var.timeouts, "create", "10m")
    update = lookup(var.timeouts, "update", "10m")
    delete = lookup(var.timeouts, "delete", "10m")
  }
}
