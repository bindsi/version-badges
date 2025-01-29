/**
 * # Onboard Infrastructure Requirements
 *
 * Creates the required resources needed for an edge IaC deployment.
 */

locals {
  resource_group_id = try(azurerm_resource_group.aio_rg[0].id, data.azurerm_resource_group.existing_aio_rg[0].id)
}

# Defer computation to prevent `data` objects from querying for state on `terraform plan`.
# Needed for testing and build system.
resource "terraform_data" "defer" {
  input = {
    resource_group_name = coalesce(
      var.resource_group_name,
      "rg-${var.resource_prefix}-${var.environment}-${var.instance}"
    )
  }
}

resource "azurerm_resource_group" "aio_rg" {
  count = var.should_create_resource_group ? 1 : 0

  name     = terraform_data.defer.output.resource_group_name
  location = var.location
}

data "azurerm_resource_group" "existing_aio_rg" {
  count = var.should_create_resource_group ? 0 : 1

  name = terraform_data.defer.output.resource_group_name
}

module "onboard_identity" {
  source = "./modules/onboard-identity"

  count = var.should_create_onboard_identity ? 1 : 0

  depends_on = [azurerm_resource_group.aio_rg]

  location              = var.location
  resource_group_name   = terraform_data.defer.output.resource_group_name
  resource_prefix       = var.resource_prefix
  resource_group_id     = local.resource_group_id
  onboard_identity_type = var.onboard_identity_type
}
