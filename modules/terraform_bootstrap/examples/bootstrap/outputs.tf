// You don't need to copy data from this file
// The reason why this file exists is because it is used for test of the module itself.
// Test can be found in the test directory.

output "state_bucket" {
  value       = module.bootstrap.state_bucket
  description = "S3 bucket ID"
}

output "dynamodb_table" {
  value       = module.bootstrap.dynamodb_table
  description = "DynamoDB table name"
}