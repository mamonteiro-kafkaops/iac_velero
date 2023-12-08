provider "aws" {
  region              = "eu-central-1"
  allowed_account_ids = [var.aws_account_id] # ensure that each stage is deployed to the right AWS account

  default_tags {
    tags = {
      "kn:knite:mep:environment" = var.environment
      "kn:ccc:product:name"      = var.default_tag_value_kn_ccc_product_name_tag_value
      "kn:ccc:environment:stage" = var.default_tag_value_kn_ccc_environment_stage
    }
  }
}