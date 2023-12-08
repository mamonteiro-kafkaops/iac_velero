data "aws_region" "current" {}

data "aws_kms_key" "s3_backend_kms_key" {
  key_id = "alias/mep/s3/terraform-state"
}
