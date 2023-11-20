##############################################################################
# Outputs
##############################################################################

output "secrets_manager_guid" {
  value       = ibm_resource_instance.secrets_manager.guid
  description = "GUID of Secrets Manager instance."
}

output "iam_secret_generator_apikey" {
  value       = module.iam_engine.iam_secret_generator_apikey
  description = "API Key value of ServiceID used to configure the Secrets-Manager IAM engine"
  sensitive   = true
}

output "secrets_manager_iam_secret_generator_apikey_secret_id" {
  value       = module.iam_engine.iam_secret_generator_apikey_secret_id
  description = "Secret ID containing IAM secret generator serviceID API key"
}

output "secrets_manager_group_acct_secret_group_id" {
  value       = module.iam_engine.acct_secret_group_id
  description = "ID of created group_acct secret-group"
}
