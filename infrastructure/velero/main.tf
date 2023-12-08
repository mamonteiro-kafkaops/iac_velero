module "kms_key" {
  source      = "cloudposse/kms-key/aws"
  version     = "0.12.1"
  environment = local.base_name
  name        = "velero"
  policy      = data.aws_iam_policy_document.velero_kms_key.json
  alias       = "alias/velero"
}


module "velero_bucket" {
  source                  = "cloudposse/s3-bucket/aws"
  version                 = "4.0.0"
  name                    = "velero"
  namespace               = data.aws_caller_identity.current.id
  environment             = data.aws_region.current.name
  sse_algorithm           = "aws:kms"
  kms_master_key_arn      = module.kms_key.key_arn
  allow_ssl_requests_only = true
  lifecycle_rules         = []
  force_destroy           = true
  privileged_principal_arns = [
    { "arn:aws:iam::${var.aws_account_id}:role/velero" = [""] }
  ]
  privileged_principal_actions = [
    "s3:PutObject",
    "s3:PutObjectAcl",
    "s3:GetObject",
    "s3:DeleteObject",
    "s3:ListBucket",
    "s3:ListBucketMultipartUploads",
    "s3:GetBucketLocation",
    "s3:AbortMultipartUpload"
  ]
}

/*resource "helm_release" "velero" {
  name             = "helm-velero-1"
  repository       = "https://vmware-tanzu.github.io/helm-charts"
  chart            = "velero"
  namespace        = "velero"
  version          = "5.1.0" #appversion 1.12.0
  values           = [file("../../charts/velero/environments/${var.environment}/values.yaml")]
  create_namespace = false
  depends_on       = [module.velero_bucket]
}*/
