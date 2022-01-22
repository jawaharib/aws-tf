variable "env" {
  type        = string
  description = "The desired AWS account environment for app."
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "bucket_purpose" {
  type        = string
  default     = "tf-state"
  description = "Name to identify the bucket's purpose"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "A boolean that indicates the S3 bucket can be destroyed even if it contains objects. These objects are not recoverable"
}

variable "mfa_delete" {
  type        = bool
  default     = false
  description = "A boolean that indicates that versions of S3 objects can only be deleted with MFA."
}

variable "prevent_unencrypted_uploads" {
  type        = bool
  default     = true
  description = "Prevent uploads of unencrypted objects to S3"
}

variable "enable_public_access_block" {
  type        = bool
  default     = true
  description = "Enable Bucket Public Access Block"
}

variable "block_public_acls" {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should block public ACLs for this bucket"
}

variable "ignore_public_acls" {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should ignore public ACLs for this bucket"
}

variable "block_public_policy" {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should block public bucket policies for this bucket"
}

variable "restrict_public_buckets" {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket"
}

variable "s3_bucket_tags" {
  type = map(string)
  default = {
    automation  = "terraform"
    environment = "dev"
  }
  description = "Tags of the AWS S3."
}

variable "log_name" {
  type        = string
  default     = "log"
  description = "Access log name"
}

variable "log_retention" {
  type        = number
  default     = 90
  description = "Log retention of access logs of state bucket."
}

variable "dynamodb_table_name" {
  type        = string
  default     = "terraform-state-lock"
  description = "Name of the DynamoDB table for locking terraform state."
}

variable "enable_server_side_encryption" {
  type        = bool
  description = "Enable DynamoDB server-side encryption"
  default     = true
}

variable "enable_point_in_time_recovery" {
  type        = bool
  default     = true
  description = "Enable DynamoDB point-in-time recovery"
}

variable "dynamodb_table_tags" {
  type = map(string)
  default = {
    automation  = "terraform"
    name        = "terraform-state-lock"
    environment = "dev"
  }
  description = "Tags of the DynamoDB Table for locking Terraform state."
}
