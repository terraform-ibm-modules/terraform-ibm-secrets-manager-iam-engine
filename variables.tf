##############################################################################
# Required input variables
##############################################################################

variable "region" {
  type        = string
  description = "The region in which the secrets-manager instance exists."
}

variable "secrets_manager_guid" {
  type        = string
  description = "The GUID of the secrets-manager instance."
}

##############################################################################
# Optional input variables
##############################################################################
variable "iam_secret_generator_service_id_name" {
  type        = string
  description = "Optionally override the name of the Service ID that will be created to configure the secrets-manager IAM secret engine. If null, the default value will be \"sid:0.0.1:$${secrets_manager_name}-iam-secret-generator:automated:simple-service:secret-manager:\""
  default     = null
}

variable "iam_secret_generator_apikey_name" {
  type        = string
  description = "Name of ServiceID API Key to be created for Secrets Manager IAM Secret engine"
  default     = "iam-secret-generator-apikey"
}

variable "iam_secret_generator_apikey_description" {
  type        = string
  description = "Description of ServiceID API Key to be created for Secrets Manager IAM Secret engine"
  default     = "ServiceID API Key to be created for Secrets Manager IAM Secret engine"
}

variable "new_secret_group_name" {
  type        = string
  description = "The name of a new secret group to create. This is the group that the Service ID (used to configure IAM secret engine) apikey secret will be added to. Ignored if value passed for var.existing_secret_group_id."
  default     = "account-secret-group"
}

variable "existing_secret_group_id" {
  type        = string
  description = "The ID of an existing secret group that the Service ID (used to configure IAM secret engine) apikey secret will be added to. If null, a new group is created using the value in var.new_secret_group_name."
  default     = null
}

variable "iam_secret_generator_apikey_secret_name" {
  type        = string
  description = "Name of the secret to add to secrets-manager which contains the ServiceID API Key"
  default     = "iam-secret-generator-apikey-secret"
}

variable "iam_secret_generator_apikey_secret_labels" {
  type        = list(string)
  description = "Labels of the secret to create. Up to 30 labels can be created. Labels can be 2 - 30 characters, including spaces. Special characters that are not permitted include the angled brackets (<>), comma (,), colon (:), ampersand (&), and vertical pipe character (|)."
  default     = []

  validation {
    condition     = (length(var.iam_secret_generator_apikey_secret_labels) <= 30) && (length(var.iam_secret_generator_apikey_secret_labels) > 0 ? can([for label in var.iam_secret_generator_apikey_secret_labels : regex("^[^<>,:&|]{2,30}$", label)]) : true)
    error_message = "Up to 30 labels can be created. Labels can be 2 - 30 characters, including spaces. Special characters that are not permitted include the angled brackets (<>), comma (,), colon (:), ampersand (&), and vertical pipe character (|)."
  }
}

variable "display_iam_secret_generator_apikey" {
  type        = bool
  description = "Set to true to display the iam_secret_generator_apikey serviceID API Key in output. Should only be used by account admins."
  default     = false
}

variable "endpoint_type" {
  type        = string
  description = "The service endpoint type to communicate with the provided secrets manager instance. Possible values are `public` or `private`"
  default     = "public"
  validation {
    condition     = contains(["public", "private"], var.endpoint_type)
    error_message = "The specified endpoint_type is not a valid selection!"
  }
}

variable "iam_engine_name" {
  type        = string
  description = "The name of the IAM Engine to create."
}

variable "add_service_id_creator_role" {
  type        = bool
  description = "Optionally, add service id creator role to the generated service id. This is only required if the creation of service IDs in your IAM settings is disabled."
  default     = false
}

##############################################################################
