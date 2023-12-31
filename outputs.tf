##############################################################################
# Outputs
##############################################################################

output "iam_secret_generator_apikey" {
  value       = local.apikey_output
  description = "API Key value of ServiceID used to configure the Secrets-Manager IAM engine"
  sensitive   = true
}

output "iam_secret_generator_apikey_secret_id" {
  value       = module.secrets_manager_secret_iam_secret_generator_apikey.secret_id
  description = "Secret ID containing IAM secret generator serviceID API key"
}

output "acct_secret_group_id" {
  value       = local.secret_group_id
  description = "ID of created group_acct secret-group"
}

##############################################################################
