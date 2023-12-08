locals {
  oidc_eks           = replace(data.aws_eks_cluster.eks_cluster_data.identity[0].oidc[0].issuer, "https://", "")
  base_name          = "velero-${var.environment}"
  velero_bucket_name = "${var.aws_account_id}-${var.region}-velero"
}