variable "intra_subnet_tags" {
  description = "Additional tags for the intra subnets"
  type        = map(string)
  default     = {}
}

variable "extra_security_group_ids" {
  default     = []
  type        = list(string)
  description = "Extra Security Group To Attach"
}

############ IAM ##############


######### Common ###########

variable "tags_as_map" {
  description = "A map of tags and values in the same format as other resources accept. This will be converted into the non-standard format that the aws_autoscaling_group requires."
  type        = map(string)
  default     = {}
}


