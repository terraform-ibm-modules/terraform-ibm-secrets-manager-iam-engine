##############################################################################
# Input Variables
##############################################################################

variable "region" {
  type        = string
  description = "Region where all resources in this example will be created"
  default     = "us-south"
}

variable "prefix" {
  type        = string
  description = "Prefix for sm instance"
  default     = "iam-engine-test"
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example, if unset a new resource group will be created"
  default     = null
}

variable "ibmcloud_api_key" {
  type        = string
  description = "An IBM Cloud apikey from an account in which resources will be created"
  sensitive   = true
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "sm_service_plan" {
  type        = string
  description = "Type of service plan to use to provision Secrets Manager if not using an existing one."
  default     = "trial"
}
