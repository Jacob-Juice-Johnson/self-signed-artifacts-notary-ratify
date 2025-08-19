# Create Resource Group
module "resource_group" {
  source = "./modules/resource-group"

  name     = "${local.project_name}-rg"
  location = local.location
  tags     = local.common_tags
}

# Create Azure Container Registry
module "acr" {
  source = "./modules/acr"

  name                = "${replace(local.project_name, "-", "")}acr"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  sku                 = "Basic"
  tags                = local.common_tags
}

# Create Key Vault
module "key_vault" {
  source = "./modules/keyvault"

  name                = "${local.project_name}-kv"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags                = local.common_tags
}

# Create Self-Signed Certificate
module "certificate" {
  source = "./modules/certificate"

  certificate_name    = "${local.project_name}-kv-cert"
  key_vault_name      = module.key_vault.name
  resource_group_name = module.resource_group.name
  policy_file_path    = "./certificate-policy.json"
  tags                = local.common_tags
}

# Create AKS Cluster
module "aks" {
  source = "./modules/aks"

  name                = "${local.project_name}-aks"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  dns_prefix          = "${local.project_name}-aks"
  node_count          = var.aks_node_count
  vm_size             = var.aks_vm_size
  tags                = local.common_tags
}

# Create Ratify with Azure Policy (uses the created AKS cluster)
module "ratify" {
  source = "./modules/ratify"

  aks_cluster_id      = module.aks.id
  akv_name            = module.key_vault.name
  cert_name           = "${local.project_name}-kv-cert"

  excluded_namespaces = []

  depends_on = [module.certificate]
}
