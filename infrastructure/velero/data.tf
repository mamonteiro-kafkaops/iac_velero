data "aws_eks_cluster" "eks_cluster_data" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster_data" {
  name = var.eks_cluster_name
}

data "aws_kms_alias" "kms_key_ebs_alias" {
  name = "alias/mep/ebs"
}

data "aws_kms_key" "kms_key_ebs" {
  key_id = data.aws_kms_alias.kms_key_ebs_alias.target_key_id
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}