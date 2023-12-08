terraform {
  # https://github.com/hashicorp/terraform/releases
  required_version = ">= 1.5.0"

  required_providers {
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.14.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.11.0"
    }
  }
}
