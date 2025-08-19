# Ratify Terraform Module with Azur  # Optional variables
  chart_version            = "1.15.0"
  namespace_name          = "gatekeeper-system"
  cert_name              = "ratify-cert"
  policy_definition_name = "ratify-custom-policy"
  policy_assignment_name = "ratify-policy"
  policy_effect          = "Deny"  # or "Audit"
  excluded_namespaces    = ["kube-system", "gatekeeper-system", "azure-system"]
}

This Terraform module deploys Ratify on AKS with a custom Azure Policy for container image signature verification.

## Features

- Deploys Ratify using Helm chart to a Kubernetes namespace
- Creates and assigns a custom Azure Policy for image signature verification
- Supports both "Deny" and "Audit" policy effects
- Configures Azure Workload Identity for ACR and Key Vault access
- Sets up Notation trust policies for container image verification
- **Configurable namespace exclusions** for policy scope control

## Prerequisites

1. **AKS cluster** with OIDC issuer enabled
2. **Azure Policy add-on** enabled on the AKS cluster
3. **User-assigned managed identity** with federated credentials
4. **Azure Key Vault** containing signing certificates
5. **Azure Container Registry** connected to the AKS cluster

## Usage

```hcl
module "ratify" {
  source = "./modules/ratify"

  # Required variables
  aks_cluster_id     = azurerm_kubernetes_cluster.main.id
  identity_client_id = azurerm_user_assigned_identity.ratify.client_id
  akv_name           = azurerm_key_vault.main.name
  akv_tenant_id      = data.azurerm_client_config.current.tenant_id
  repo_uri           = "${azurerm_container_registry.main.login_server}/myapp"
  subject            = "CN=ratify-cert,O=MyOrg,L=Seattle,ST=WA,C=US"

  # Optional variables
  chart_version          = "1.15.0"
  namespace_name         = "gatekeeper-system"
  cert_name              = "ratify-cert"
  policy_definition_name = "ratify-custom-policy"
  policy_assignment_name = "ratify-policy"
  policy_effect          = "Deny"  # or "Audit"
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aks_cluster_id | Resource ID of the AKS cluster | `string` | n/a | yes |
| identity_client_id | Azure Workload Identity client ID | `string` | n/a | yes |
| akv_name | Name of the Azure Key Vault | `string` | n/a | yes |
| akv_tenant_id | Azure tenant ID for the Key Vault | `string` | n/a | yes |
| repo_uri | Container registry URI for trust policy scope | `string` | n/a | yes |
| subject | X.509 subject for trusted certificate identity | `string` | n/a | yes |
| chart_version | Version of the Ratify Helm chart | `string` | `"1.15.0"` | no |
| namespace_name | Kubernetes namespace for Ratify | `string` | `"gatekeeper-system"` | no |
| cert_name | Name of the certificate in Key Vault | `string` | `"ratify-cert"` | no |
| policy_definition_name | Name for the Azure Policy definition | `string` | `"ratify-default-custom-policy"` | no |
| policy_assignment_name | Name for the Azure Policy assignment | `string` | `"ratify-policy-assignment"` | no |
| policy_effect | Policy effect: Deny or Audit | `string` | `"Deny"` | no |
| excluded_namespaces | List of Kubernetes namespaces to exclude from policy evaluation | `list(string)` | `["kube-system", "gatekeeper-system"]` | no |

## Outputs

| Name | Description |
|------|-------------|
| policy_definition_id | The ID of the created Azure Policy definition |
| policy_assignment_id | The ID of the Azure Policy assignment |
| namespace_name | The namespace where Ratify is installed |

## Policy Effects

### Deny Effect (Default)
- Only signed images from trusted identities are allowed for deployment
- Unsigned images or images signed by untrusted identities are denied

### Audit Effect
- All images can be deployed
- Non-compliant deployments (unsigned or untrusted) are marked for auditing
- Useful for testing configuration without blocking deployments

## Testing the Policy

After deployment, you can test the policy with different image types:

```bash
# This should succeed (signed image)
kubectl run demo-signed --image=myregistry.azurecr.io/myapp:signed

# This should fail with Deny effect (unsigned image)
kubectl run demo-unsigned --image=myregistry.azurecr.io/myapp:unsigned
```

## Policy Assignment Timeline

Note that it takes approximately **15 minutes** for the Azure Policy assignment to take effect. You can check the status with:

```bash
kubectl get constraintTemplate ratifyverification
```

## Troubleshooting

1. **Check Ratify logs**:
   ```bash
   kubectl logs -l app.kubernetes.io/name=ratify -n gatekeeper-system
   ```

2. **Verify policy status**:
   ```bash
   kubectl get constraintTemplate ratifyverification
   kubectl get ratifyverification
   ```

3. **Check policy compliance**:
   Use Azure Portal to view policy compliance data and understand why deployments might be failing.

## References

- [Microsoft Documentation - Validating image signatures using Ratify and AKS](https://learn.microsoft.com/en-us/azure/security/container-secure-supply-chain/articles/validating-image-signatures-using-ratify-aks)
- [Ratify Project Documentation](https://ratify.dev/)
- [Azure Policy for Kubernetes](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/policy-for-kubernetes)
