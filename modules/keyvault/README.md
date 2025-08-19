# Azure Key Vault Terraform Module

A simple Azure Key Vault module designed for demo purposes with public network access enabled.

## Features

- Creates Azure Key Vault with configurable settings
- Public network access enabled for demo purposes
- Soft delete enabled with configurable retention period
- Purge protection disabled by default for easier cleanup
- Automatic access policy for current Terraform client
- Support for additional access policies

## Usage

```hcl
module "key_vault" {
  source = "./modules/keyvault"

  name                = "my-demo-keyvault"
  location            = "East US"
  resource_group_name = "my-resource-group"
  
  tags = {
    Environment = "Demo"
    Purpose     = "Container Image Signing"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the Azure Key Vault | `string` | n/a | yes |
| location | The Azure region where the Key Vault will be created | `string` | n/a | yes |
| resource_group_name | The name of the resource group where the Key Vault will be created | `string` | n/a | yes |
| sku_name | The SKU of the Azure Key Vault | `string` | `"standard"` | no |
| public_network_access_enabled | Whether public network access is enabled for the Key Vault | `bool` | `true` | no |
| purge_protection_enabled | Whether purge protection is enabled (set to false for demo to allow deletion) | `bool` | `false` | no |
| soft_delete_retention_days | Number of days to retain deleted keys, secrets, and certificates | `number` | `7` | no |
| additional_access_policies | Additional access policies for the Key Vault | `map(object(...))` | `{}` | no |
| tags | A map of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Azure Key Vault |
| name | The name of the Azure Key Vault |
| vault_uri | The URI of the Azure Key Vault |
| tenant_id | The Azure Tenant ID |
| location | The location of the Azure Key Vault |
| resource_group_name | The resource group name containing the Azure Key Vault |

## Notes

- This module is designed for demo purposes with public network access enabled
- Purge protection is disabled by default to allow easier cleanup of demo resources
- The current Terraform client is automatically granted full access to the Key Vault
- Additional access policies can be configured via the `additional_access_policies` variable
