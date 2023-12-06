# Variable validation - approach based on https://stackoverflow.com/a/66682419
locals {
  validate_group_cnd = var.existing_secret_group_id == null && (var.new_secret_group_name == null || var.new_secret_group_name == "")
  validate_group_msg = "A value must be passed for either var.existing_secret_group_id or var.new_secret_group_name"
  # tflint-ignore: terraform_unused_declarations
  validate_group_code_chk = regex(
    "^${local.validate_group_msg}$",
    (!local.validate_group_cnd
      ? local.validate_group_msg
  : ""))
}

# Create ServiceID to be used in SM IAM engine
locals {
  service_id_name = var.iam_secret_generator_service_id_name != null ? var.iam_secret_generator_service_id_name : "sid:0.0.1:${var.secrets_manager_guid}-iam-secret-generator:automated:simple-service:secret-manager:"
}

resource "ibm_iam_service_id" "iam_secret_generator" {
  name        = local.service_id_name
  description = "ServiceID that can generate IAM ServiceID API Keys stored in Secrets Manager secrets"
}

# Create ServiceID policies to generate IAM secrets
resource "ibm_iam_service_policy" "iam_secret_generator_policy1" {
  iam_service_id = ibm_iam_service_id.iam_secret_generator.id
  roles          = ["Editor"]

  resources {
    service = "iam-groups"
  }
}

# create policy for iam identity service
locals {
  iam_identity_roles = var.add_service_id_creator_role ? ["Operator", "Service ID creator"] : ["Operator"]
}

resource "ibm_iam_service_policy" "iam_secret_generator_policy2" {
  iam_service_id = ibm_iam_service_id.iam_secret_generator.id
  roles          = local.iam_identity_roles

  resources {
    service = "iam-identity"
  }
}

resource "ibm_iam_service_api_key" "iam_serviceid_apikey" {
  name           = var.iam_secret_generator_apikey_name
  description    = var.iam_secret_generator_apikey_description
  iam_service_id = ibm_iam_service_id.iam_secret_generator.iam_id
}

moved {
  from = ibm_iam_service_api_key.sdnlb_serviceid_apikey
  to   = ibm_iam_service_api_key.iam_serviceid_apikey
}

# Variable to extract API key value
locals {
  apikey        = one(ibm_iam_service_api_key.iam_serviceid_apikey[*])["apikey"]
  apikey_output = var.display_iam_secret_generator_apikey == true ? nonsensitive(local.apikey) : "not-displayed"
}

# Create secrets-manager secret group if an existing secret group ID not passed in
module "secrets_manager_group_acct" {
  count                    = (var.existing_secret_group_id == null) ? 1 : 0
  source                   = "terraform-ibm-modules/secrets-manager-secret-group/ibm"
  version                  = "1.1.3"
  region                   = var.region
  secrets_manager_guid     = var.secrets_manager_guid
  secret_group_name        = var.new_secret_group_name
  secret_group_description = "Secret-Group for storing account credentials"
}

# Determine the secret group ID
locals {
  secret_group_id = var.existing_secret_group_id != null ? var.existing_secret_group_id : module.secrets_manager_group_acct[0].secret_group_id
}

# Create secrets-manager secret
module "secrets_manager_secret_iam_secret_generator_apikey" {
  source                  = "terraform-ibm-modules/secrets-manager-secret/ibm"
  version                 = "1.1.1"
  region                  = var.region
  secrets_manager_guid    = var.secrets_manager_guid
  secret_name             = var.iam_secret_generator_apikey_secret_name
  secret_description      = "Secret containing API key of SM iam_secret_generator service ID"
  secret_payload_password = local.apikey
  secret_group_id         = local.secret_group_id
  secret_labels           = var.iam_secret_generator_apikey_secret_labels
  secret_type             = "arbitrary"
}

# Create IAM Engine
resource "ibm_sm_iam_credentials_configuration" "sm_iam_engine_configuration" {
  instance_id   = var.secrets_manager_guid
  region        = var.region
  endpoint_type = var.service_endpoints
  name          = var.iam_engine_name
  api_key       = local.apikey
  depends_on = [
    ibm_iam_service_policy.iam_secret_generator_policy2, ibm_iam_service_policy.iam_secret_generator_policy1
  ]
}
