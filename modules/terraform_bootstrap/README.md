# Bootstrapping Terraform

When you starting with working with `terraform` you might notice, we need to share our work through
[states](https://www.terraform.io/docs/language/state/index.html) and this state should be stored in the [backend](https://www.terraform.io/docs/language/settings/backends/index.html).

This module will solve the problem, where we just started our work with terraform and we need to bootstrap account.
It takes the approach of keeping a local statefile in the repo that only manages these resources:

- AWS Account Alias for the AWS account
- S3 bucket for remote state file
- S3 bucket for storing state bucket access logs
- DynamoDB table for state locking and consistency checking

If the AWS account you are using already has a Terraform state bucket and locking table, this may not be the right module for you.

- [Bootstrapping Terraform](#bootstrapping-terraform)
  - [Requirements](#requirements)
  - [Usage](#usage)
  - [Test](#test)
  - [Input Variables](#input-variables)
    - [Required](#required)
    - [Optional](#optional)
  - [Output Values](#output-values)
  - [Managed Resources](#managed-resources)
  - [Data Resources](#data-resources)

## Requirements

Core Version Constraints:

- `>= 0.13.0`

Provider Requirements:

- **aws (`hashicorp/aws`):** `>= 3.0`

## Usage

```terraform
module "bootstrap" {
  source = "../modules/terraform_bootstrap"

  region        = "ap-southeast-1"
  env           = "dev"
}
```

## Input Variables

### Required

- `region` (required): AWS Region

### Optional

- `block_public_acls` (default `true`): Whether Amazon S3 should block public ACLs for this bucket
- `block_public_policy` (default `true`): Whether Amazon S3 should block public bucket policies for this bucket
- `bucket_purpose` (default `"tf-state"`): Name to identify the bucket's purpose
- `dynamodb_table_name` (default `"terraform-state-lock"`): Name of the DynamoDB table for locking terraform state.
- `dynamodb_table_tags` (default `{"automation":"terraform","name":"terraform-state-lock"}`): Tags of the DynamoDB Table for locking Terraform state.
- `enable_point_in_time_recovery` (default `true`): Enable DynamoDB point-in-time recovery
- `enable_public_access_block` (default `true`): Enable Bucket Public Access Block
- `enable_server_side_encryption` (default `true`): Enable DynamoDB server-side encryption
- `force_destroy` (default `false`): A boolean that indicates the S3 bucket can be destroyed even if it contains objects. These objects are not recoverable
- `ignore_public_acls` (default `true`): Whether Amazon S3 should ignore public ACLs for this bucket
- `log_name` (default `"log"`): Access log name
- `log_retention` (default `90`): Log retention of access logs of state bucket.
- `mfa_delete` (default `false`): A boolean that indicates that versions of S3 objects can only be deleted with MFA.
- `prevent_unencrypted_uploads` (default `true`): Prevent uploads of unencrypted objects to S3
- `restrict_public_buckets` (default `true`): Whether Amazon S3 should restrict public bucket policies for this bucket
- `s3_bucket_tags` (default `{"automation":"terraform"}`): Tags of the AWS S3.

## Output Values

- `dynamodb_table`: The Terraform DynamoDB locking table. More details https://www.terraform.io/docs/language/settings/backends/s3.html
- `state_bucket`: The Terraform S3 state bucket name. More details https://www.terraform.io/docs/language/settings/backends/s3.html
- `log_bucket`:

## Managed Resources

- `aws_dynamodb_table.terraform_state_lock` from `aws`
- `aws_s3_bucket.log_bucket` from `aws`
- `aws_s3_bucket.state_bucket` from `aws`
- `aws_s3_bucket_public_access_block.default` from `aws`

## Data Resources

- `data.aws_iam_policy_document.prevent_unencrypted_uploads` from `aws`
