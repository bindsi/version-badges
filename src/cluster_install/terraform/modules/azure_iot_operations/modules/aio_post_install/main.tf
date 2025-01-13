/**
 * # Azure IoT Instance post-installation enablement 
 *
 * Enables secret-sync on the Azure IoT instance after the instance is created.
 *
 */

data "azurerm_subscription" "current" {}

resource "terraform_data" "enable_aio_instance_secret_sync" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "az iot ops secretsync enable --instance ${var.instance_name} --resource-group ${var.resource_group_name} --mi-user-assigned ${data.azurerm_user_assigned_identity.existing_sse_user_managed_identity.id} --kv-resource-id ${data.azurerm_key_vault.existing_key_vault.id}"
  }
  count = var.is_sse_standalone_enabled ? 0 : 1
}

resource "azurerm_federated_identity_credential" "federated_identity_cred_sse_aio" {
  name                = "aio-sse-ficred"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = data.azapi_resource.cluster_oidc_issuer[0].output.properties.oidcIssuerProfile.issuerUrl
  parent_id           = data.azurerm_user_assigned_identity.existing_sse_user_managed_identity.id
  subject             = "system:serviceaccount:${var.aio_namespace}:aio-ssc-sa" # Service account name must be this value, this is currently not documented but hard-coded in CLI, eg here: https://github.com/Azure/azure-iot-ops-cli-extension/blob/dev/azext_edge/edge/providers/orchestration/resources/instances.py#L38
  count               = var.is_sse_standalone_enabled ? 1 : 0
}

resource "azapi_resource" "default_aio_keyvault_secret_provider_class" {
  type      = "Microsoft.SecretSyncController/azureKeyVaultSecretProviderClasses@2024-08-21-preview"
  name      = "spc-ops-aio" # Name can be anything, as the Digital Operations Experience (DOE) searches for the SPC by the custom location and resource group, this is not documented but found through default install values and testing
  location  = var.connected_cluster_location
  parent_id = var.resource_group_id

  body = {
    extendedLocation = {
      name = var.custom_location_id
      type = "CustomLocation"
    }
    properties = {
      clientId     = data.azurerm_user_assigned_identity.existing_sse_user_managed_identity.client_id
      keyvaultName = data.azurerm_key_vault.existing_key_vault.name
      tenantId     = data.azurerm_subscription.current.tenant_id
    }
  }

  count = var.is_sse_standalone_enabled ? 1 : 0
}

data "azapi_resource" "cluster_oidc_issuer" {
  name      = var.connected_cluster_name
  parent_id = var.resource_group_id
  type      = "Microsoft.Kubernetes/connectedClusters@2024-12-01-preview"

  response_export_values = ["properties.oidcIssuerProfile.issuerUrl"]

  count = var.is_sse_standalone_enabled ? 1 : 0
}

# reference an existing key vault resource
data "azurerm_key_vault" "existing_key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_user_assigned_identity" "existing_sse_user_managed_identity" {
  name                = var.sse_user_managed_identity_name
  resource_group_name = var.resource_group_name
}
