terraform {
  backend "s3" {
    region     = "eu-central-1"
    key        = "mep-velero-provisioning-role.tfstate"
    profile    = ""
    role_arn   = ""
    encrypt    = "true"
    kms_key_id = "alias/mep/s3/terraform-state"
  }
}