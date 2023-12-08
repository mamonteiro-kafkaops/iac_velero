resource "aws_iam_role" "velero_role" {
  name = "velero"

  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  // AWS managed policies
  managed_policy_arns = []

  inline_policy {
    name   = "s3"
    policy = data.aws_iam_policy_document.s3.json
  }

  inline_policy {
    name   = "ebs"
    policy = data.aws_iam_policy_document.ebs.json
  }

  inline_policy {
    name   = "kms_ebs"
    policy = data.aws_iam_policy_document.ebs_kms.json
  }
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:oidc-provider/${local.oidc_eks}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_eks}:sub"

      values = [
        "system:serviceaccount:velero:velero-server"
      ]
    }
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts"
    ]
    resources = ["arn:aws:s3:::${local.velero_bucket_name}/*"]
  }
}

data "aws_iam_policy_document" "ebs" {
  statement {
    actions = [
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ebs_kms" {
  statement {
    actions = [
      "kms:ReEncrypt*"
    ]
    resources = [data.aws_kms_key.kms_key_ebs.arn]
  }
}

data "aws_iam_policy_document" "velero_kms_key" {
  statement {
    sid = "Enable IAM User Permissions"

    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }
    resources = ["*"]     #checkov:skip=CKV_AWS_111:Not applicable to account root principle
    actions   = ["kms:*"] #checkov:skip=CKV_AWS_109:Not applicable to account root principle
  }
  //arn:aws:kms:eu-central-1:934382447941:key/2adaff99-424d-4f0a-a55f-15d01af7206e
  statement {
    sid = "Allow Velero to use key for S3"

    principals {
      identifiers = [aws_iam_role.velero_role.arn]
      type        = "AWS"
    }

    resources = ["*"]
    actions   = ["kms:*"]

    condition {
      test     = "StringEquals"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values   = ["arn:aws:s3:::${local.velero_bucket_name}"]
    }
  }
}

data "aws_iam_policy_document" "kms_s3_key" {
  statement {
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
    resources = [module.kms_key.key_arn]
  }
}

resource "aws_iam_policy" "kms_s3_key" {
  name        = "velero_kms_s3"
  description = "Policy to allow Velero generate key data from the master key for S3 bucket."
  policy      = data.aws_iam_policy_document.kms_s3_key.json
}

resource "aws_iam_policy_attachment" "kms_s3_key" {
  name       = "velero_kms_s3_attachment"
  roles      = [aws_iam_role.velero_role.name]
  policy_arn = aws_iam_policy.kms_s3_key.arn
}
