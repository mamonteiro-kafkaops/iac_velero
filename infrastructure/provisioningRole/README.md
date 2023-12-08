# provisioningRole

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.14.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.25.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tf_backend_policy_document"></a> [tf\_backend\_policy\_document](#module\_tf\_backend\_policy\_document) | git::https://git.int.kn/scm/mep/tf_aws_iam_policy_documents.git//modules/terraform-backend-policy-document | v1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.provision_velero](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [random_uuid.external_id](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/uuid) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecr_push_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.iam_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.provision_velero_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.provision_velero_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_key.s3_backend_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | target AWS account id in which the roles should be created in. | `string` | n/a | yes |
| <a name="input_default_tag_value_kn_ccc_environment_stage"></a> [default\_tag\_value\_kn\_ccc\_environment\_stage](#input\_default\_tag\_value\_kn\_ccc\_environment\_stage) | The pre-defined tag value for tag 'kn:ccc:environment:stage'. Following values are defined: dev, test, uat, int, prod, training, sandbox. Please take a look on https://jira.int.kn/browse/DAPI-162?focusedCommentId=4028066&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-4028066 to choose the right value. | `string` | n/a | yes |
| <a name="input_default_tag_value_kn_ccc_product_name_tag_value"></a> [default\_tag\_value\_kn\_ccc\_product\_name\_tag\_value](#input\_default\_tag\_value\_kn\_ccc\_product\_name\_tag\_value) | The tag value for tag 'kn:ccc:product:name'. | `string` | `"Message + Event Platform"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment to provision (e.g. dev-infra, production) | `string` | n/a | yes |
| <a name="input_gitlab_runner_role_arn"></a> [gitlab\_runner\_role\_arn](#input\_gitlab\_runner\_role\_arn) | The gitlab runner role arn that we will trust | `string` | `"arn:aws:iam::728725878968:role/gitlab-runner-mep-role"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"eu-central-1"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
