variable "aws_account_id" {
  description = "target AWS account id in which the roles should be created in."
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "eu-central-1"
}


variable "environment" {
  description = "Name of the environment to provision (e.g. dev-infra, production)"
  type        = string
}

variable "default_tag_value_kn_ccc_environment_stage" {
  // @see: https://wiki.int.kn/display/CCC/Tagging+strategies#Taggingstrategies-Environmenttags
  description = "The pre-defined tag value for tag 'kn:ccc:environment:stage'. Following values are defined: dev, test, uat, int, prod, training, sandbox. Please take a look on https://jira.int.kn/browse/DAPI-162?focusedCommentId=4028066&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-4028066 to choose the right value."
  type        = string
}

variable "default_tag_value_kn_ccc_product_name_tag_value" {
  // @see: https://wiki.int.kn/display/CCC/Tagging+strategies#Taggingstrategies-Nameanddescriptiontags
  description = "The tag value for tag 'kn:ccc:product:name'."
  type        = string
  default     = "Message + Event Platform"
}

variable "gitlab_runner_role_arn" {
  description = "The gitlab runner role arn that we will trust"
  type        = string
  default     = "arn:aws:iam::728725878968:role/gitlab-runner-mep-role"
}