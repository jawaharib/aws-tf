output "state_bucket" {
  description = "The Terraform S3 state bucket name. More details https://www.terraform.io/docs/language/settings/backends/s3.html"
  value       = local.state_bucket
}

output "log_bucket" {
  value       = local.logging_bucket
  description = ""
}

output "dynamodb_table" {
  description = "The Terraform DynamoDB locking table. More details https://www.terraform.io/docs/language/settings/backends/s3.html"
  value       = aws_dynamodb_table.terraform_state_lock.id
}