
# Module `modules/ec2-key-pair/`

Core Version Constraints:
* `>= 0.12.6`

Provider Requirements:
* **aws:** `>= 2.46`

## Input Variables
* `create_key_pair` (default `true`): Controls if key pair should be created
* `key_name` (default `null`): The name for the key pair.
* `key_name_prefix` (default `null`): Creates a unique name beginning with the specified prefix. Conflicts with key_name.
* `public_key` (default `""`): The public key material.
* `tags` (default `{}`): A map of tags to add to key pair resource.

## Output Values
* `key_pair_fingerprint`: The MD5 public key fingerprint as specified in section 4 of RFC 4716.
* `key_pair_key_name`: The key pair name.
* `key_pair_key_pair_id`: The key pair ID.

## Managed Resources
* `aws_key_pair.this` from `aws`

