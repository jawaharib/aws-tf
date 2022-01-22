provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

module "bootstrap" {
  source = "../../modules/terraform_bootstrap"

  region = var.region
  env    = var.env

  // The variables below you can ignore and not paste in your invocation to the module,
  // we will set defaults to meet best practicers
  dynamodb_table_name = var.dynamodb_table_name
  bucket_purpose      = var.bucket_purpose
}
