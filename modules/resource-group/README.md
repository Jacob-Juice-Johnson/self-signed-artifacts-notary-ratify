# Simple Resource Group Module

A very simple Terraform module that creates an Azure Resource Group.

## Usage

```hcl
module "resource_group" {
  source = "./modules/resource-group"

  name     = "my-demo-rg"
  location = "East US"
  
  tags = {
    Environment = "Demo"
    Purpose     = "Container Image Signing"
  }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| name | Resource group name | string | yes |
| location | Azure region | string | yes |
| tags | Tags for the resource group | map(string) | no |

## Outputs

| Name | Description |
|------|-------------|
| id | Resource group ID |
| name | Resource group name |
| location | Resource group location |
