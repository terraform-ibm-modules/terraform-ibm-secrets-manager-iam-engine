module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.1"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

# Create Secrets Manager Instance
resource "ibm_resource_instance" "secrets_manager" {
  name              = "${var.prefix}-sm"
  service           = "secrets-manager"
  plan              = "trial"
  location          = var.region
  tags              = var.resource_tags
  resource_group_id = module.resource_group.resource_group_id

  timeouts {
    create = "30m" # Extending provisioning time to 30 minutes
  }
}

# Configure instance with IAM engine
module "iam_engine" {
  source               = "../.."
  region               = var.region
  secrets_manager_guid = ibm_resource_instance.secrets_manager.guid
  iam_engine_name      = "generated_iam_engine"
}
