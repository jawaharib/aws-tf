
# Module `modules/ec2/`

Core Version Constraints:
* `>= 0.12.6`

Provider Requirements:
* **aws:** `>= 3.24`

## Input Variables
* `ami` (required): ID of AMI to use for the instance
* `associate_public_ip_address` (default `null`): If true, the EC2 instance will have associated public IP address
* `cpu_credits` (default `"standard"`): The credit option for CPU usage (unlimited or standard)
* `disable_api_termination` (default `false`): If true, enables EC2 Instance Termination Protection
* `ebs_block_device` (default `[]`): Additional EBS block devices to attach to the instance
* `ebs_optimized` (default `false`): If true, the launched EC2 instance will be EBS-optimized
* `enable_volume_tags` (default `true`): Whether to enable volume tags (if enabled it conflicts with root_block_device tags)
* `ephemeral_block_device` (default `[]`): Customize Ephemeral (also known as Instance Store) volumes on the instance
* `get_password_data` (default `false`): If true, wait for password data to become available and retrieve it.
* `iam_instance_profile` (default `""`): The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile.
* `instance_count` (default `1`): Number of instances to launch
* `instance_initiated_shutdown_behavior` (default `""`): Shutdown behavior for the instance
* `instance_type` (required): The type of instance to start
* `ipv6_address_count` (default `null`): A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet.
* `ipv6_addresses` (default `null`): Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface
* `key_name` (default `""`): The key name to use for the instance
* `metadata_options` (default `{}`): Customize the metadata options of the instance
* `monitoring` (default `false`): If true, the launched EC2 instance will have detailed monitoring enabled
* `name` (required): Name to be used on all resources as prefix
* `network_interface` (default `[]`): Customize network interfaces to be attached at instance boot time
* `num_suffix_format` (default `"-%d"`): Numerical suffix format used as the volume and EC2 instance name suffix
* `placement_group` (default `""`): The Placement Group to start the instance in
* `private_ip` (default `null`): Private IP address to associate with the instance in a VPC
* `private_ips` (default `[]`): A list of private IP address to associate with the instance in a VPC. Should match the number of instances.
* `root_block_device` (default `[]`): Customize details about the root block device of the instance. See Block Devices below for details
* `source_dest_check` (default `true`): Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs.
* `subnet_id` (default `""`): The VPC Subnet ID to launch in
* `subnet_ids` (default `[]`): A list of VPC Subnet IDs to launch in
* `tags` (default `{}`): A mapping of tags to assign to the resource
* `tenancy` (default `"default"`): The tenancy of the instance (if the instance is running in a VPC). Available values: default, dedicated, host.
* `use_num_suffix` (default `false`): Always append numerical suffix to instance name, even if instance_count is 1
* `user_data` (default `null`): The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead.
* `user_data_base64` (default `null`): Can be used instead of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption.
* `volume_tags` (default `{}`): A mapping of tags to assign to the devices created by the instance at launch time
* `vpc_security_group_ids` (default `null`): A list of security group IDs to associate with

## Output Values
* `arn`: List of ARNs of instances
* `availability_zone`: List of availability zones of instances
* `credit_specification`: List of credit specification of instances
* `ebs_block_device_volume_ids`: List of volume IDs of EBS block devices of instances
* `id`: List of IDs of instances
* `instance_count`: Number of instances to launch specified as argument to this module
* `instance_state`: List of instance states of instances
* `ipv6_addresses`: List of assigned IPv6 addresses of instances
* `key_name`: List of key names of instances
* `metadata_options`: List of metadata options of instances
* `password_data`: List of Base-64 encoded encrypted password data for the instance
* `placement_group`: List of placement groups of instances
* `primary_network_interface_id`: List of IDs of the primary network interface of instances
* `private_dns`: List of private DNS names assigned to the instances. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC
* `private_ip`: List of private IP addresses assigned to the instances
* `public_dns`: List of public DNS names assigned to the instances. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC
* `public_ip`: List of public IP addresses assigned to the instances, if applicable
* `root_block_device_volume_ids`: List of volume IDs of root block devices of instances
* `security_groups`: List of associated security groups of instances
* `subnet_id`: List of IDs of VPC subnets of instances
* `tags`: List of tags of instances
* `volume_tags`: List of tags of volumes of instances
* `vpc_security_group_ids`: List of associated security groups of instances, if running in non-default VPC

## Managed Resources
* `aws_instance.this` from `aws`

