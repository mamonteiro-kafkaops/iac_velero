terraform {
  # https://github.com/hashicorp/terraform/releases
  required_version = ">= 1.5.0"

  required_providers {
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.14.0"
    }
    # https://registry.terraform.io/providers/hashicorp/random/latest/docs
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}
