
# Module `modules/vpc/`

Core Version Constraints:
* `>= 0.12.26`

Provider Requirements:
* **aws (`hashicorp/aws`):** `>= 3.15`

## Input Variables
* `amazon_side_asn` (default `"64512"`): The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the virtual private gateway is created with the current default Amazon ASN.
* `app_name` (default `""`): Name of application.
* `assign_ipv6_address_on_creation` (default `false`): Assign IPv6 address on subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
* `azs` (default `[]`): A list of availability zones names or ids in the region
* `cidr` (default `"0.0.0.0/0"`): The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden
* `create_database_internet_gateway_route` (default `false`): Controls if an internet gateway route for public database access should be created
* `create_database_nat_gateway_route` (default `false`): Controls if a nat gateway route should be created to give internet access to the database subnets
* `create_database_subnet_group` (default `true`): Controls if database subnet group should be created (n.b. database_subnets must also be set)
* `create_database_subnet_route_table` (default `false`): Controls if separate route table for database should be created
* `create_egress_only_igw` (default `true`): Controls if an Egress Only Internet Gateway is created and its related routes.
* `create_flow_log_cloudwatch_iam_role` (default `false`): Whether to create IAM role for VPC Flow Logs
* `create_flow_log_cloudwatch_log_group` (default `false`): Whether to create CloudWatch log group for VPC Flow Logs
* `create_igw` (default `true`): Controls if an Internet Gateway is created for public subnets and the related routes that connect them.
* `create_vpc` (default `true`): Controls if VPC should be created (it affects almost all resources)
* `customer_gateway_tags` (default `{}`): Additional tags for the Customer Gateway
* `customer_gateways` (default `{}`): Maps of Customer Gateway's attributes (BGP ASN and Gateway's Internet-routable external IP address)
* `database_acl_tags` (default `{}`): Additional tags for the database subnets network ACL
* `database_dedicated_network_acl` (default `false`): Whether to use dedicated network ACL (not default) and custom rules for database subnets
* `database_inbound_acl_rules` (default `[{"cidr_block":"0.0.0.0/0","from_port":0,"protocol":"-1","rule_action":"allow","rule_number":100,"to_port":0}]`): Database subnets inbound network ACL rules
* `database_outbound_acl_rules` (default `[{"cidr_block":"0.0.0.0/0","from_port":0,"protocol":"-1","rule_action":"allow","rule_number":100,"to_port":0}]`): Database subnets outbound network ACL rules
* `database_route_table_tags` (default `{}`): Additional tags for the database route tables
* `database_subnet_assign_ipv6_address_on_creation` (default `null`): Assign IPv6 address on database subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
* `database_subnet_group_tags` (default `{}`): Additional tags for the database subnet group
* `database_subnet_ipv6_prefixes` (default `[]`): Assigns IPv6 database subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list
* `database_subnet_suffix` (default `"db"`): Suffix to append to database subnets name
* `database_subnet_tags` (default `{}`): Additional tags for the database subnets
* `database_subnets` (default `[]`): A list of database subnets
* `default_network_acl_egress` (default `[{"action":"allow","cidr_block":"0.0.0.0/0","from_port":0,"protocol":"-1","rule_no":100,"to_port":0},{"action":"allow","from_port":0,"ipv6_cidr_block":"::/0","protocol":"-1","rule_no":101,"to_port":0}]`): List of maps of egress rules to set on the Default Network ACL
* `default_network_acl_ingress` (default `[{"action":"allow","cidr_block":"0.0.0.0/0","from_port":0,"protocol":"-1","rule_no":100,"to_port":0},{"action":"allow","from_port":0,"ipv6_cidr_block":"::/0","protocol":"-1","rule_no":101,"to_port":0}]`): List of maps of ingress rules to set on the Default Network ACL
* `default_network_acl_name` (default `""`): Name to be used on the Default Network ACL
* `default_network_acl_tags` (default `{}`): Additional tags for the Default Network ACL
* `default_route_table_propagating_vgws` (default `[]`): List of virtual gateways for propagation
* `default_route_table_routes` (default `[]`): Configuration block of routes. See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table#route
* `default_route_table_tags` (default `{}`): Additional tags for the default route table
* `default_security_group_egress` (default `null`): List of maps of egress rules to set on the default security group
* `default_security_group_ingress` (default `null`): List of maps of ingress rules to set on the default security group
* `default_security_group_name` (default `"default"`): Name to be used on the default security group
* `default_security_group_tags` (default `{}`): Additional tags for the default security group
* `default_vpc_enable_classiclink` (default `false`): Should be true to enable ClassicLink in the Default VPC
* `default_vpc_enable_dns_hostnames` (default `false`): Should be true to enable DNS hostnames in the Default VPC
* `default_vpc_enable_dns_support` (default `true`): Should be true to enable DNS support in the Default VPC
* `default_vpc_name` (default `""`): Name to be used on the Default VPC
* `default_vpc_tags` (default `{}`): Additional tags for the Default VPC
* `dhcp_options_domain_name` (default `""`): Specifies DNS name for DHCP options set (requires enable_dhcp_options set to true)
* `dhcp_options_domain_name_servers` (default `["AmazonProvidedDNS"]`): Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable_dhcp_options set to true)
* `dhcp_options_netbios_name_servers` (default `[]`): Specify a list of netbios servers for DHCP options set (requires enable_dhcp_options set to true)
* `dhcp_options_netbios_node_type` (default `""`): Specify netbios node_type for DHCP options set (requires enable_dhcp_options set to true)
* `dhcp_options_ntp_servers` (default `[]`): Specify a list of NTP servers for DHCP options set (requires enable_dhcp_options set to true)
* `dhcp_options_tags` (default `{}`): Additional tags for the DHCP option set (requires enable_dhcp_options set to true)
* `enable_classiclink` (default `null`): Should be true to enable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic.
* `enable_classiclink_dns_support` (default `null`): Should be true to enable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic.
* `enable_dhcp_options` (default `false`): Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type
* `enable_dns_hostnames` (default `false`): Should be true to enable DNS hostnames in the VPC
* `enable_dns_support` (default `true`): Should be true to enable DNS support in the VPC
* `enable_flow_log` (default `false`): Whether or not to enable VPC Flow Logs
* `enable_ipv6` (default `false`): Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block.
* `enable_nat_gateway` (default `false`): Should be true if you want to provision NAT Gateways for each of your private networks
* `enable_vpn_gateway` (default `false`): Should be true if you want to create a new VPN Gateway resource and attach it to the VPC
* `env` (required): Name of the application environment.
* `external_nat_ip_ids` (default `[]`): List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips)
* `external_nat_ips` (default `[]`): List of EIPs to be used for `nat_public_ips` output (used in combination with reuse_nat_ips and external_nat_ip_ids)
* `flow_log_cloudwatch_iam_role_arn` (default `""`): The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group. When flow_log_destination_arn is set to ARN of Cloudwatch Logs, this argument needs to be provided.
* `flow_log_cloudwatch_log_group_kms_key_id` (default `null`): The ARN of the KMS Key to use when encrypting log data for VPC flow logs.
* `flow_log_cloudwatch_log_group_name_prefix` (default `"/aws/vpc-flow-log/"`): Specifies the name prefix of CloudWatch Log Group for VPC flow logs.
* `flow_log_cloudwatch_log_group_retention_in_days` (default `null`): Specifies the number of days you want to retain log events in the specified log group for VPC flow logs.
* `flow_log_destination_arn` (default `""`): The ARN of the CloudWatch log group or S3 bucket where VPC Flow Logs will be pushed. If this ARN is a S3 bucket the appropriate permissions need to be set on that bucket's policy. When create_flow_log_cloudwatch_log_group is set to false this argument must be provided.
* `flow_log_destination_type` (default `"cloud-watch-logs"`): Type of flow log destination. Can be s3 or cloud-watch-logs.
* `flow_log_log_format` (default `null`): The fields to include in the flow log record, in the order in which they should appear.
* `flow_log_max_aggregation_interval` (default `600`): The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds or `600` seconds.
* `flow_log_traffic_type` (default `"ALL"`): The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL.
* `igw_tags` (default `{}`): Additional tags for the internet gateway
* `instance_tenancy` (default `"default"`): A tenancy option for instances launched into the VPC
* `manage_default_network_acl` (default `false`): Should be true to adopt and manage Default Network ACL
* `manage_default_route_table` (default `false`): Should be true to manage default route table
* `manage_default_security_group` (default `false`): Should be true to adopt and manage default security group
* `manage_default_vpc` (default `false`): Should be true to adopt and manage Default VPC
* `map_public_ip_on_launch` (default `true`): Should be false if you do not want to auto-assign public IP on launch
* `name` (default `""`): Name to be used on all the resources as identifier
* `nat_eip_tags` (default `{}`): Additional tags for the NAT EIP
* `nat_gateway_tags` (default `{}`): Additional tags for the NAT gateways
* `one_nat_gateway_per_az` (default `false`): Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`.
* `outpost_acl_tags` (default `{}`): Additional tags for the outpost subnets network ACL
* `outpost_arn` (default `null`): ARN of Outpost you want to create a subnet in.
* `outpost_az` (default `null`): AZ where Outpost is anchored.
* `outpost_dedicated_network_acl` (default `false`): Whether to use dedicated network ACL (not default) and custom rules for outpost subnets
* `outpost_inbound_acl_rules` (default `[{"cidr_block":"0.0.0.0/0","from_port":0,"protocol":"-1","rule_action":"allow","rule_number":100,"to_port":0}]`): Outpost subnets inbound network ACLs
* `outpost_outbound_acl_rules` (default `[{"cidr_block":"0.0.0.0/0","from_port":0,"protocol":"-1","rule_action":"allow","rule_number":100,"to_port":0}]`): Outpost subnets outbound network ACLs
* `outpost_subnet_assign_ipv6_address_on_creation` (default `null`): Assign IPv6 address on outpost subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
* `outpost_subnet_ipv6_prefixes` (default `[]`): Assigns IPv6 outpost subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list
* `outpost_subnet_suffix` (default `"outpost"`): Suffix to append to outpost subnets name
* `outpost_subnet_tags` (default `{}`): Additional tags for the outpost subnets
* `outpost_subnets` (default `[]`): A list of outpost subnets inside the VPC
* `private_acl_tags` (default `{}`): Additional tags for the private subnets network ACL
* `private_dedicated_network_acl` (default `false`): Whether to use dedicated network ACL (not default) and custom rules for private subnets
* `private_inbound_acl_rules` (default `[{"cidr_block":"0.0.0.0/0","from_port":0,"protocol":"-1","rule_action":"allow","rule_number":100,"to_port":0}]`): Private subnets inbound network ACLs
* `private_outbound_acl_rules` (default `[{"cidr_block":"0.0.0.0/0","from_port":0,"protocol":"-1","rule_action":"allow","rule_number":100,"to_port":0}]`): Private subnets outbound network ACLs
* `private_route_table_tags` (default `{}`): Additional tags for the private route tables
* `private_subnet_assign_ipv6_address_on_creation` (default `null`): Assign IPv6 address on private subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
* `private_subnet_ipv6_prefixes` (default `[]`): Assigns IPv6 private subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list
* `private_subnet_suffix` (default `"pvt"`): Suffix to append to private subnets name
* `private_subnet_tags` (default `{}`): Additional tags for the private subnets
* `private_subnets` (default `[]`): A list of private subnets inside the VPC
* `propagate_private_route_tables_vgw` (default `false`): Should be true if you want route table propagation
* `propagate_public_route_tables_vgw` (default `false`): Should be true if you want route table propagation
* `public_acl_tags` (default `{}`): Additional tags for the public subnets network ACL
* `public_dedicated_network_acl` (default `false`): Whether to use dedicated network ACL (not default) and custom rules for public subnets
* `public_inbound_acl_rules` (default `[{"cidr_block":"0.0.0.0/0","from_port":0,"protocol":"-1","rule_action":"allow","rule_number":100,"to_port":0}]`): Public subnets inbound network ACLs
* `public_outbound_acl_rules` (default `[{"cidr_block":"0.0.0.0/0","from_port":0,"protocol":"-1","rule_action":"allow","rule_number":100,"to_port":0}]`): Public subnets outbound network ACLs
* `public_route_table_tags` (default `{}`): Additional tags for the public route tables
* `public_subnet_assign_ipv6_address_on_creation` (default `null`): Assign IPv6 address on public subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
* `public_subnet_ipv6_prefixes` (default `[]`): Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list
* `public_subnet_suffix` (default `"pub"`): Suffix to append to public subnets name
* `public_subnet_tags` (default `{}`): Additional tags for the public subnets
* `public_subnets` (default `[]`): A list of public subnets inside the VPC
* `reuse_nat_ips` (default `false`): Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable
* `secondary_cidr_blocks` (default `[]`): List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool
* `single_nat_gateway` (default `false`): Should be true if you want to provision a single shared NAT Gateway across all of your private networks
* `tags` (default `{}`): A map of tags to add to all resources
* `vpc_flow_log_permissions_boundary` (default `null`): The ARN of the Permissions Boundary for the VPC Flow Log IAM Role
* `vpc_flow_log_tags` (default `{}`): Additional tags for the VPC Flow Logs
* `vpc_tags` (default `{}`): Additional tags for the VPC
* `vpn_gateway_az` (default `null`): The Availability Zone for the VPN Gateway
* `vpn_gateway_id` (default `""`): ID of VPN Gateway to attach to the VPC
* `vpn_gateway_tags` (default `{}`): Additional tags for the VPN gateway

## Output Values
* `database_subnets`: List of IDs of dtaabase subnets
* `default_route_table_id`: The ID of the default route table
* `default_security_group_id`: The ID of the security group created by default on VPC creation
* `private_route_table_ids`: List of IDs of private route tables
* `private_subnets`: List of IDs of private subnets
* `public_route_table_ids`: List of IDs of public route tables
* `public_subnets`: List of IDs of public subnets
* `vpc_id`: The ID of the VPC

## Managed Resources
* `aws_db_subnet_group.database` from `aws`
* `aws_default_network_acl.this` from `aws`
* `aws_default_route_table.default` from `aws`
* `aws_default_security_group.this` from `aws`
* `aws_default_vpc.this` from `aws`
* `aws_egress_only_internet_gateway.this` from `aws`
* `aws_eip.nat` from `aws`
* `aws_internet_gateway.this` from `aws`
* `aws_nat_gateway.this` from `aws`
* `aws_network_acl.database` from `aws`
* `aws_network_acl.private` from `aws`
* `aws_network_acl.public` from `aws`
* `aws_network_acl_rule.database_inbound` from `aws`
* `aws_network_acl_rule.database_outbound` from `aws`
* `aws_network_acl_rule.private_inbound` from `aws`
* `aws_network_acl_rule.private_outbound` from `aws`
* `aws_network_acl_rule.public_inbound` from `aws`
* `aws_network_acl_rule.public_outbound` from `aws`
* `aws_route.database_internet_gateway` from `aws`
* `aws_route.database_ipv6_egress` from `aws`
* `aws_route.database_nat_gateway` from `aws`
* `aws_route.private_ipv6_egress` from `aws`
* `aws_route.private_nat_gateway` from `aws`
* `aws_route.public_internet_gateway` from `aws`
* `aws_route.public_internet_gateway_ipv6` from `aws`
* `aws_route_table.database` from `aws`
* `aws_route_table.private` from `aws`
* `aws_route_table.public` from `aws`
* `aws_route_table_association.database` from `aws`
* `aws_route_table_association.private` from `aws`
* `aws_route_table_association.public` from `aws`
* `aws_subnet.database` from `aws`
* `aws_subnet.private` from `aws`
* `aws_subnet.public` from `aws`
* `aws_vpc.this` from `aws`
* `aws_vpc_dhcp_options.this` from `aws`
* `aws_vpc_dhcp_options_association.this` from `aws`
* `aws_vpc_ipv4_cidr_block_association.this` from `aws`

