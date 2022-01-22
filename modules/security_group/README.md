
# Module `modules/security_group/`

Provider Requirements:
* **aws:** (any version)

## Input Variables
* `app_name` (required)
* `env` (required)
* `security_group` (default `{}`)
* `tags` (default `{}`)
* `vpc_id` (required): VPC Id where subnet is to be created.

## Output Values
* `id`

## Managed Resources
* `aws_security_group.this` from `aws`
