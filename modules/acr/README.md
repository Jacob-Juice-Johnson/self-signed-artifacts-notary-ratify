# Simple Azure Container Registry (ACR) Terraform Module

This Terraform module creates a simple Azure Container Registry with Basic or Standard SKU. It's designed for straightforward use cases without the complexity of Premium features.

## Features

- **Simple Configuration**: Minimal required variables
- **Basic/Standard SKU Support**: Cost-effective options for most use cases
- **Optional Admin Access**: Enable admin user if needed
- **Network Control**: Configure public network access
- **Anonymous Pull**: Optional anonymous pull capability

## Usage

### Basic ACR

```hcl
module "acr" {
  source = "./modules/acr"

  name                = "myacrregistry"
  resource_group_name = "rg-container-registry"
  location            = "East US"
  
  tags = {
    Environment = "Development"
    Team        = "DevOps"
  }
}
```

### ACR with Admin Enabled

```hcl
module "acr" {
  source = "./modules/acr"

  name                = "myacrregistry"
  resource_group_name = "rg-container-registry"
  location            = "East US"
  sku                 = "Standard"
  admin_enabled       = true
  
  tags = {
    Environment = "Production"
    Team        = "DevOps"
  }
}
```

### ACR with Anonymous Pull

```hcl
module "acr" {
  source = "./modules/acr"

  name                = "myacrregistry"
  resource_group_name = "rg-container-registry"
  location            = "East US"
  sku                 = "Standard"
  anonymous_pull_enabled = true
  
  tags = {
    Environment = "Public"
    Purpose     = "Open Source"
  }
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the Azure Container Registry | `string` | n/a | yes |
| resource_group_name | The name of the resource group | `string` | n/a | yes |
| location | The Azure region where the ACR will be created | `string` | n/a | yes |
| sku | The SKU of the Azure Container Registry (Basic or Standard) | `string` | `"Standard"` | no |
| admin_enabled | Whether admin user is enabled | `bool` | `false` | no |
| public_network_access_enabled | Whether public network access is allowed | `bool` | `true` | no |
| anonymous_pull_enabled | Whether anonymous pull is enabled | `bool` | `false` | no |
| tags | A map of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Azure Container Registry |
| name | The name of the Azure Container Registry |
| login_server | The login server of the Azure Container Registry |
| admin_username | The admin username (if admin is enabled) |
| admin_password | The admin password (if admin is enabled) |
| resource_group_name | The name of the resource group |
| location | The Azure region where the ACR is deployed |
| sku | The SKU of the Azure Container Registry |

## SKU Comparison

| Feature | Basic | Standard |
|---------|-------|----------|
| Storage (GB) | 10 | 100 |
| ReadOps per minute | 1,000 | 3,000 |
| WriteOps per minute | 100 | 500 |
| Download bandwidth (Mbps) | 30 | 60 |
| Upload bandwidth (Mbps) | 10 | 20 |
| Webhooks | ❌ | ✅ |

## Integration with AKS

To integrate this ACR with Azure Kubernetes Service:

```hcl
# Create ACR
module "acr" {
  source = "./modules/acr"
  
  name                = "myacrregistry"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

# Grant AKS cluster access to ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
```

## Authentication Options

### 1. Azure AD Authentication (Recommended)
Use Azure AD identities for authentication - no additional configuration needed in this module.

### 2. Admin User (Simple but less secure)
```hcl
module "acr" {
  source = "./modules/acr"
  
  # ... other configuration ...
  admin_enabled = true
}

# Access credentials via outputs
output "acr_username" {
  value = module.acr.admin_username
  sensitive = true
}

output "acr_password" {
  value = module.acr.admin_password
  sensitive = true
}
```

### 3. Anonymous Pull (Public repositories)
```hcl
module "acr" {
  source = "./modules/acr"
  
  # ... other configuration ...
  anonymous_pull_enabled = true
}
```

## Security Best Practices

1. **Use Azure AD Authentication**: Prefer Azure AD over admin users when possible
2. **Disable Public Access**: Set `public_network_access_enabled = false` for sensitive workloads
3. **Use Standard SKU**: For production workloads, use Standard SKU for better performance
4. **Enable Monitoring**: Set up diagnostic settings and monitoring (configured separately)

## Example with AKS Integration

```hcl
# Resource group
resource "azurerm_resource_group" "main" {
  name     = "rg-container-platform"
  location = "East US"
}

# Create ACR
module "acr" {
  source = "./modules/acr"

  name                = "mycompanyregistry"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Standard"

  tags = {
    Environment = "Production"
    Project     = "ContainerPlatform"
  }
}

# Create AKS cluster (simplified)
resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-main"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "aksmain"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Grant AKS access to ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

# Output ACR login server for use in deployments
output "acr_login_server" {
  value = module.acr.login_server
}
```

## License

This module is released under the MIT License.
