locals {
  velero_provisioning_role_name = "VeleroProvisioning"
  tf_state_dynamodb_table_name  = "${var.aws_account_id}-${data.aws_region.current.name}-${var.environment}-terraform-state-lock"
  tf_state_s3_bucket_name       = "${var.aws_account_id}-${data.aws_region.current.name}-${var.environment}-terraform-state"
}

resource "aws_iam_role" "provision_velero" {
  name = local.velero_provisioning_role_name

  assume_role_policy = data.aws_iam_policy_document.assume_role.json


  inline_policy {
    name   = "tfbackend"
    policy = module.tf_backend_policy_document.policy_document_json
  }

  inline_policy {
    name   = "eks"
    policy = data.aws_iam_policy_document.provision_velero_eks.json
  }

  inline_policy {
    name   = "s3"
    policy = data.aws_iam_policy_document.provision_velero_s3.json
  }

  inline_policy {
    name   = "ecr"
    policy = data.aws_iam_policy_document.ecr_push_policy.json
  }

  inline_policy {
    name   = "kms"
    policy = data.aws_iam_policy_document.kms.json
  }

  inline_policy {
    name   = "iam_roles"
    policy = data.aws_iam_policy_document.iam_roles.json
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AccountAdmin"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:role/Administrator"]
    }
  }

  statement {
    sid     = "GitlabProject"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      // grant permissions to gitlab pipeline
      identifiers = [var.gitlab_runner_role_arn]
    }
    condition {
      test     = "StringEquals"
      values   = [random_uuid.external_id.id]
      variable = "sts:ExternalId"
    }
  }
}


resource "random_uuid" "external_id" {
}

module "tf_backend_policy_document" {
  source                   = "git::https://git.int.kn/scm/mep/tf_aws_iam_policy_documents.git//modules/terraform-backend-policy-document?ref=v1.0.0"
  aws_account_id           = var.aws_account_id
  aws_region               = data.aws_region.current.name
  dynamodb_lock_table_name = local.tf_state_dynamodb_table_name
  tf_state_s3_bucket_name  = local.tf_state_s3_bucket_name
  tf_state_s3_object_key   = "mep-velero*"
  kms_key_arn              = data.aws_kms_key.s3_backend_kms_key.arn
}

data "aws_iam_policy_document" "provision_velero_eks" {
  statement {
    actions   = ["eks:DescribeCluster"]
    resources = ["arn:aws:eks:${data.aws_region.current.name}:${var.aws_account_id}:cluster/*"]
  }
}

data "aws_iam_policy_document" "provision_velero_s3" {
  statement {
    actions = [
      "s3:*Bucket*",
      "s3:*Configuration"
    ]

    resources = ["arn:aws:s3:::*"]

    condition {
      test     = "StringEquals"
      values   = [var.aws_account_id]
      variable = "s3:ResourceAccount"
    }
  }
}

data "aws_iam_policy_document" "ecr_push_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]

    resources = [
      "arn:aws:ecr:${var.region}:${var.aws_account_id}:repository/velero*"
    ]
  }
}



data "aws_iam_policy_document" "kms" {
  statement {
    sid = "kms"
    actions = [
      "kms:ListAliases",
      "kms:CreateKey",
    ]
    resources = ["*"]
  }

  statement {
    sid = "kmsScoped"
    actions = [
      "kms:CreateAlias",
      "kms:DeleteAlias",
      "kms:DescribeKey",
      "kms:EnableKeyRotation",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:ListResourceTags",
      "kms:TagResource",
      "kms:ScheduleKeyDeletion",
      "kms:UntagResource",
      "kms:CreateGrant",
      "kms:PutKeyPolicy"
    ]
    resources = ["arn:aws:kms:*:${var.aws_account_id}:*"]
  }
}

data "aws_iam_policy_document" "iam_roles" {
  statement {
    sid = "iam"
    actions = [
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicies",
      "iam:ListPolicyVersions",
      "iam:ListEntitiesForPolicy"
    ]
    resources = ["*"]
  }

  statement {
    sid = "iamScoped"
    actions = [
      "iam:AttachRolePolicy",
      "iam:CreateOpenIDConnectProvider",
      "iam:CreatePolicy",
      "iam:CreatePolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:CreateRole",
      "iam:DeleteOpenIDConnectProvider",
      "iam:DeletePolicy",
      "iam:DeleteRolePolicy",
      "iam:DeleteRole",
      "iam:DetachRolePolicy",
      "iam:GetOpenIDConnectProvider",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:ListPolicies",
      "iam:ListRolePolicies",
      "iam:TagOpenIDConnectProvider",
      "iam:TagPolicy",
      "iam:TagRole",
      "iam:UntagOpenIDConnectProvider",
      "iam:UntagPolicy",
      "iam:UntagRole",
      "iam:UpdateRole",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
      "iam:UpdateAssumeRolePolicy"
    ]
    resources = [
      "arn:aws:iam::${var.aws_account_id}:role/velero*",
      "arn:aws:iam::${var.aws_account_id}:policy/*"
    ]
  }
}

