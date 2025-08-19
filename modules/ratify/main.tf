# Create namespace for Ratify
resource "kubernetes_namespace" "ratify" {
  metadata {
    name = var.namespace_name
  }
}

resource "helm_release" "ratify" {
  name       = "ratify"
  repository = "https://ratify-project.github.io/ratify"
  chart      = "ratify"
  version    = var.chart_version
  namespace  = kubernetes_namespace.ratify.metadata[0].name

  depends_on = [kubernetes_namespace.ratify]

  set {
    name  = "provider.enableMutation"
    value = "false"
  }

  set {
    name  = "featureFlags.RATIFY_CERT_ROTATION"
    value = "true"
  }

  set {
    name  = "azureWorkloadIdentity.clientId"
    value = var.identity_client_id
  }

  set {
    name  = "oras.authProviders.azureWorkloadIdentityEnabled"
    value = "true"
  }

  set {
    name  = "azurekeyvault.enabled"
    value = "true"
  }

  set {
    name  = "azurekeyvault.vaultURI"
    value = "https://${var.akv_name}.vault.azure.net"
  }

  set {
    name  = "azurekeyvault.certificates[0].name"
    value = var.cert_name
  }

  set {
    name  = "azurekeyvault.tenantId"
    value = var.akv_tenant_id
  }

  set {
    name  = "notation.trustPolicies[0].registryScopes[0]"
    value = var.repo_uri
  }

  set {
    name  = "notation.trustPolicies[0].trustStores[0]"
    value = "ca:azurekeyvault"
  }

  set {
    name  = "notation.trustPolicies[0].trustedIdentities[0]"
    value = "x509.subject: ${var.subject}"
  }

  atomic  = true
}