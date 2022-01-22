variable "app_name" {
  description = "Application name."
}

variable "env" {
  description = "Environment name."
}

variable "create" {
  description = "Determines whether resources will be created"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "The ID of the VPC in which the endpoint will be used"
  type        = string
  default     = ""
}

variable "endpoints" {
  description = "A map of interface and/or gateway endpoints containing their properties and configurations"
  type        = any
  default     = {}
}

variable "security_group_ids" {
  description = "Default security group IDs to associate with the VPC endpoints"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "Default subnets IDs to associate with the VPC endpoints"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting VPC endpoint resources"
  type        = map(string)
  default     = {}
}


variable "vpc_endpoint_type" {
  default     = "Interface"
  description = "The VPC endpoint type, Gateway, GatewayLoadBalancer, or Interface. Defaults to Gateway"
}
variable "auto_accept" {
  default     = null
  description = "Accept the VPC endpoint (the VPC endpoint and service need to be in the same AWS account)"
}
variable "route_table_ids" {
  default     = null
  description = "One or more route table IDs. Applicable for endpoints of type Gateway."
}
variable "policy" {
  default     = null
  description = "A policy to attach to the endpoint that controls access to the service. Defaults to full access. "
}
variable "private_dns_enabled" {
  default     = false
  description = "AWS services and AWS Marketplace partner services only) Whether or not to associate a private hosted zone with the specified VPC."
}

variable "service_type" {
  default     = "Interface"
  description = "The service type, Gateway or Interface."
}
variable "service_name" {
  default     = null
  description = "The service name that is specified when creating a VPC endpoint."
}
variable "service" {
  default     = null
  description = "The common name of an AWS service (e.g. s3)."
}
