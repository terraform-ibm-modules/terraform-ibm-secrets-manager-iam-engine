module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.6"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

# Create Secrets Manager Instance
module "secrets_manager" {
  source               = "terraform-ibm-modules/secrets-manager/ibm"
  version              = "1.25.3"
  resource_group_id    = module.resource_group.resource_group_id
  region               = var.region
  secrets_manager_name = "${var.prefix}-secrets-manager"
  sm_service_plan      = "trial"
  endpoint_type        = "public"
  sm_tags              = var.resource_tags
}

# Configure instance with IAM engine
module "iam_engine" {
  source               = "../.."
  region               = var.region
  secrets_manager_guid = module.secrets_manager.secrets_manager_guid
  iam_engine_name      = "generated_iam_engine"
}
