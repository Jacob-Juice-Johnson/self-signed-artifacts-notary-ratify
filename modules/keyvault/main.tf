# Get current client configuration
data "azurerm_client_config" "current" {}

# Create the Azure Key Vault
resource "azurerm_key_vault" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.sku_name

  # Enable public network access for demo
  public_network_access_enabled = var.public_network_access_enabled

  # Disable purge protection for demo (allows deletion)
  purge_protection_enabled = var.purge_protection_enabled

  # Soft delete retention (minimum 7 days)
  soft_delete_retention_days = var.soft_delete_retention_days

  # Access policy for the current user/service principal
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "SetIssuers",
      "Update",
    ]

    key_permissions = [
      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey",
    ]

    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set",
    ]
  }

  tags = var.tags
}

# Additional access policies for other users/service principals
resource "azurerm_key_vault_access_policy" "additional" {
  for_each = var.additional_access_policies

  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.value.object_id

  certificate_permissions = each.value.certificate_permissions
  key_permissions        = each.value.key_permissions
  secret_permissions     = each.value.secret_permissions
}
