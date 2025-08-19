variable "chart_version" {
  description = "Version of the Ratify Helm chart to install"
  type        = string
  default     = "1.15.0"
}

variable "identity_client_id" {
  description = "Azure Workload Identity client ID for Ratify"
  type        = string
  default     = ""
}

variable "akv_name" {
  description = "Name of the Azure Key Vault containing certificates"
  type        = string
  default     = ""
}

variable "cert_name" {
  description = "Name of the certificate in Azure Key Vault"
  type        = string
  default     = "ratify-cert"
}

variable "akv_tenant_id" {
  description = "Azure tenant ID for the Key Vault"
  type        = string
  default     = ""
}

variable "repo_uri" {
  description = "Container registry URI for trust policy scope"
  type        = string
  default     = ""
}

variable "subject" {
  description = "X.509 subject for trusted certificate identity"
  type        = string
  default     = "CN=ratify-cert,O=Organization,L=City,ST=State,C=US"
}

variable "namespace_name" {
  description = "Kubernetes namespace name for Ratify installation"
  type        = string
  default     = "gatekeeper-system"
}

variable "aks_cluster_id" {
  description = "Resource ID of the AKS cluster where the policy will be assigned"
  type        = string
}

variable "policy_name" {
  description = "Name for the custom Azure Policy definition"
  type        = string
  default     = "ratify-custom-policy"
}

variable "policy_effect" {
  description = "Policy effect: Deny or Audit"
  type        = string
  default     = "Deny"
  validation {
    condition     = contains(["Deny", "Audit"], var.policy_effect)
    error_message = "Policy effect must be either 'Deny' or 'Audit'."
  }
}

variable "excluded_namespaces" {
  description = "List of Kubernetes namespaces to exclude from policy evaluation"
  type        = list(string)
  default     = ["kube-system", "gatekeeper-system"]
}