# Simple AKS Module

A very simple Terraform module that creates an Azure Kubernetes Service (AKS) cluster for demo purposes.

## Usage

```hcl
module "aks" {
  source = "./modules/aks"

  name                = "demo-aks"
  location            = "East US"
  resource_group_name = "my-demo-rg"
  dns_prefix          = "demo-aks"
  node_count          = 2
  vm_size             = "Standard_D2s_v3"
  
  tags = {
    Environment = "Demo"
    Purpose     = "Container Image Signing"
  }
}
```

## Features

- System-assigned managed identity
- Single default node pool
- Basic configuration suitable for demos
- Configurable node count and VM size

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | AKS cluster name | string | - | yes |
| location | Azure region | string | - | yes |
| resource_group_name | Resource group name | string | - | yes |
| dns_prefix | DNS prefix for the cluster | string | - | yes |
| node_count | Number of nodes | number | 2 | no |
| vm_size | VM size for nodes | string | Standard_D2s_v3 | no |
| tags | Tags for the cluster | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| id | AKS cluster ID |
| name | AKS cluster name |
| fqdn | AKS cluster FQDN |
| kube_config | Kubeconfig (sensitive) |
| principal_id | Managed identity principal ID |

## Post-deployment

After creating the AKS cluster, get credentials:

```bash
az aks get-credentials --resource-group <rg-name> --name <aks-name>
```
