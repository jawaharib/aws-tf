provider "aws" {
  region = var.region
}

module "bootstrap" {
  source = "../../"

  region = var.region

  // The variables below you can ignore and not paste in your invocation to the module,
  // we will set defaults to meet best practicers
  dynamodb_table_name = var.dynamodb_table_name
  bucket_purpose      = var.bucket_purpose
}
