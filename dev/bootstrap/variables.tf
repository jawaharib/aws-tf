// You don't need to copy data from this file
// The reason why this file exists is because it is used for test of the module itself.
// Test can be found in the test directory.

variable "bucket_purpose" {
  type        = string
  default     = "tf-state"
  description = "Name to identify the bucket's purpose"
}

variable "dynamodb_table_name" {
  type        = string
  default     = "terraform-state-lock"
  description = "Name of the DynamoDB table for locking terraform state."
}
