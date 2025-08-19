# policy.tf - Azure Policy resources for Ratify

# Load the custom policy JSON from local file
locals {
  policy_json = jsondecode(file("${path.module}/policy-definition.json"))
}

# Create the custom Azure Policy definition
resource "azurerm_policy_definition" "ratify_custom_policy" {
  name         = var.policy_name
  policy_type  = "Custom"
  mode         = "Microsoft.Kubernetes.Data"
  display_name = "Ratify Container Image Signature Verification"
  description  = "This policy uses Ratify to verify container image signatures and only allows deployment of signed images"

  policy_rule = jsonencode(local.policy_json.policyRule)
  parameters  = jsonencode(local.policy_json.parameters)

  metadata = jsonencode({
    category = "Kubernetes"
  })
}

# Assign the policy to the AKS cluster
resource "azurerm_resource_policy_assignment" "ratify_policy_assignment" {
  name                 = "${var.policy_name}-rpa"
  resource_id          = var.aks_cluster_id
  policy_definition_id = azurerm_policy_definition.ratify_custom_policy.id
  description          = "Assign Ratify custom policy to AKS cluster for container image signature verification"
  display_name         = "Ratify Policy Assignment - ${var.policy_name}"

  parameters = jsonencode({
    effect = {
      value = var.policy_effect
    }
    excludedNamespaces = {
      value = local.combined_excluded_namespaces
    }
  })

  depends_on = [helm_release.ratify]
}
