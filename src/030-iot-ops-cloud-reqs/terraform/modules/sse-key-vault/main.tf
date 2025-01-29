/**
 * # Azure Key Vault for Secret Sync Extension
 *
 * Create or use and existing a Key Vault for Secret Sync Extension
 *
 */

data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "existing" {
  name                = var.existing_key_vault_name
  resource_group_name = var.resource_group_name

  count = var.existing_key_vault_name == null ? 0 : 1
}

resource "azurerm_key_vault" "new" {
  name                      = "${var.resource_prefix}-kv"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = "standard"
  purge_protection_enabled  = false
  enable_rbac_authorization = true

  count = var.existing_key_vault_name == null ? 1 : 0
}

locals {
  key_vault_id   = length(data.azurerm_key_vault.existing) > 0 ? data.azurerm_key_vault.existing[0].id : azurerm_key_vault.new[0].id
  key_vault_name = length(data.azurerm_key_vault.existing) > 0 ? data.azurerm_key_vault.existing[0].name : azurerm_key_vault.new[0].name
}
