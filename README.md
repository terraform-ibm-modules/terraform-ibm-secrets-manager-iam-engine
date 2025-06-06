# Secrets Manager IAM engine module

---
🕸️ Archived: This repo is no longer maintained and is archived. Its functionality has been moved into the main [Secrets Manager module and DA](https://github.com/terraform-ibm-modules/terraform-ibm-secrets-manager) by utilizing s2s IAM authorization policies. This functionality is controlled with the `skip_iam_authorization_policy` variable.
---

[![Graduated (Supported)](https://img.shields.io/badge/Status-Graduated%20(Supported)-brightgreen)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-secrets-manager-iam-engine?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-secrets-manager-iam-engine/releases/latest)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

Use this module to configure an IBM Secrets Manager [IAM credentials engine]((https://cloud.ibm.com/docs/secrets-manager?topic=secrets-manager-configure-iam-engine)) for an existing IBM Secrets Manager instance.

The module supports the following operations:

- Creates a new Service ID.
- Assigns the new Service ID "Editor" role access for `iam-groups`.
- Assigns the new Service ID "Operator" and "Service ID creator" role access for `iam-identity`.
- Creates a new API key for the Service ID.
- Optionally creates a secrets group, if an existing one is not passed in.
- Creates a new arbitrary secret in the Secret Group with the generated Service ID API key value. Because it is an arbitrary secret, the IAM engine does not create the key or manage its rotation.
- Configures the Secret Manager instance with the IAM credentials engine using the Service ID API key.

<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-secrets-manager-iam-engine](#terraform-ibm-secrets-manager-iam-engine)
* [Examples](./examples)
    * [Basic example](./examples/basic)
    * [Private only example](./examples/private)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->

## terraform-ibm-secrets-manager-iam-engine

### Usage

```hcl
provider "ibm" {
  ibmcloud_api_key = "XXXXXXXXXXXXX"
  region           = "us-south" # secrets manager instance region
}

module "iam_secrets_engine" {
  source               = "terraform-ibm-modules/secrets-manager-iam-engine/ibm"
  version              = "X.X.X"  # Replace "X.X.X" with a release version to lock into a specific release
  region               = "us-south"  # secrets manager instance region
  iam_engine_name      = "iam-engine"
  secrets_manager_guid = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
}
```

### Required IAM access policies

You need the following permissions to run this module.
- Account Management
    - **IAM Access Groups** service
        - `Editor` platform access
    - **IAM Identity** service
        - `Operator` platform access
        - `Service ID creator` service access if the service id creation is disabled in the iam settings
    - **Resource Group** service
        - `Viewer` platform access
- IAM Services
    - **Secrets Manager** service
        - `Administrator` platform access
        - `Manager` service access

<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.76.0, <2.0.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_secrets_manager_group_acct"></a> [secrets\_manager\_group\_acct](#module\_secrets\_manager\_group\_acct) | terraform-ibm-modules/secrets-manager-secret-group/ibm | 1.3.3 |
| <a name="module_secrets_manager_secret_iam_secret_generator_apikey"></a> [secrets\_manager\_secret\_iam\_secret\_generator\_apikey](#module\_secrets\_manager\_secret\_iam\_secret\_generator\_apikey) | terraform-ibm-modules/secrets-manager-secret/ibm | 1.7.0 |

### Resources

| Name | Type |
|------|------|
| [ibm_iam_service_api_key.iam_serviceid_apikey](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_service_api_key) | resource |
| [ibm_iam_service_id.iam_secret_generator](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_service_id) | resource |
| [ibm_iam_service_policy.iam_secret_generator_policy1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_service_policy) | resource |
| [ibm_iam_service_policy.iam_secret_generator_policy2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_service_policy) | resource |
| [ibm_sm_iam_credentials_configuration.sm_iam_engine_configuration](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/sm_iam_credentials_configuration) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_display_iam_secret_generator_apikey"></a> [display\_iam\_secret\_generator\_apikey](#input\_display\_iam\_secret\_generator\_apikey) | Set to true to display the iam\_secret\_generator\_apikey serviceID API Key in output. Should only be used by account admins. | `bool` | `false` | no |
| <a name="input_endpoint_type"></a> [endpoint\_type](#input\_endpoint\_type) | The endpoint type to communicate with the provided secrets manager instance. Possible values are `public` or `private` | `string` | `"public"` | no |
| <a name="input_existing_secret_group_id"></a> [existing\_secret\_group\_id](#input\_existing\_secret\_group\_id) | The ID of an existing secret group that the Service ID (used to configure IAM secret engine) apikey secret will be added to. If null, a new group is created using the value in var.new\_secret\_group\_name. | `string` | `null` | no |
| <a name="input_iam_engine_name"></a> [iam\_engine\_name](#input\_iam\_engine\_name) | The name of the IAM Engine to create. | `string` | n/a | yes |
| <a name="input_iam_secret_generator_apikey_description"></a> [iam\_secret\_generator\_apikey\_description](#input\_iam\_secret\_generator\_apikey\_description) | Description of ServiceID API Key to be created for Secrets Manager IAM Secret engine | `string` | `"ServiceID API Key to be created for Secrets Manager IAM Secret engine"` | no |
| <a name="input_iam_secret_generator_apikey_name"></a> [iam\_secret\_generator\_apikey\_name](#input\_iam\_secret\_generator\_apikey\_name) | Name of ServiceID API Key to be created for Secrets Manager IAM Secret engine | `string` | `"iam-secret-generator-apikey"` | no |
| <a name="input_iam_secret_generator_apikey_secret_labels"></a> [iam\_secret\_generator\_apikey\_secret\_labels](#input\_iam\_secret\_generator\_apikey\_secret\_labels) | Labels of the secret to create. Up to 30 labels can be created. Labels can be 2 - 30 characters, including spaces. Special characters that are not permitted include the angled brackets (<>), comma (,), colon (:), ampersand (&), and vertical pipe character (\|). | `list(string)` | `[]` | no |
| <a name="input_iam_secret_generator_apikey_secret_name"></a> [iam\_secret\_generator\_apikey\_secret\_name](#input\_iam\_secret\_generator\_apikey\_secret\_name) | Name of the secret to add to secrets-manager which contains the ServiceID API Key | `string` | `"iam-secret-generator-apikey-secret"` | no |
| <a name="input_iam_secret_generator_service_id_name"></a> [iam\_secret\_generator\_service\_id\_name](#input\_iam\_secret\_generator\_service\_id\_name) | Optionally override the name of the Service ID that will be created to configure the secrets-manager IAM secret engine. If null, the default value will be "sid:0.0.1:${secrets\_manager\_name}-iam-secret-generator:automated:simple-service:secret-manager:" | `string` | `null` | no |
| <a name="input_new_secret_group_name"></a> [new\_secret\_group\_name](#input\_new\_secret\_group\_name) | The name of a new secret group to create. This is the group that the Service ID (used to configure IAM secret engine) apikey secret will be added to. Ignored if value passed for var.existing\_secret\_group\_id. | `string` | `"account-secret-group"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region in which the secrets-manager instance exists. | `string` | n/a | yes |
| <a name="input_secrets_manager_guid"></a> [secrets\_manager\_guid](#input\_secrets\_manager\_guid) | The GUID of the secrets-manager instance. | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_acct_secret_group_id"></a> [acct\_secret\_group\_id](#output\_acct\_secret\_group\_id) | ID of created group\_acct secret-group |
| <a name="output_iam_secret_generator_apikey"></a> [iam\_secret\_generator\_apikey](#output\_iam\_secret\_generator\_apikey) | API Key value of ServiceID used to configure the Secrets-Manager IAM engine |
| <a name="output_iam_secret_generator_apikey_secret_id"></a> [iam\_secret\_generator\_apikey\_secret\_id](#output\_iam\_secret\_generator\_apikey\_secret\_id) | Secret ID containing IAM secret generator serviceID API key |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
