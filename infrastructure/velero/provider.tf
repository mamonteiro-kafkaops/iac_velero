provider "aws" {
  region = var.region
  allowed_account_ids = [
    var.aws_account_id
  ] # ensure that each stage is deployed to the right AWS account
  assume_role {
    role_arn    = var.role_arn
    external_id = var.external_id
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster_data.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster_data.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks_cluster_data.token
  }
}
