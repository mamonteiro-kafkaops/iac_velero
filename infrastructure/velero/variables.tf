variable "region" {
  description = "target AWS region."
  type        = string
  default     = "eu-central-1"
}

variable "aws_account_id" {
  description = "AWS account ID."
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "environment" {
  description = "The environment/stage name"
  type        = string
}

variable "role_arn" {
  description = "ARN of the role that terraform should assume."
  default     = "" // terraform will not assume a role
  type        = string
}

variable "external_id" {
  description = "AWS IAM external id to use when assuming role_arn"
  default     = ""
  type        = string
}

