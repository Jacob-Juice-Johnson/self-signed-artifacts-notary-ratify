variable "certificate_name" {
  description = "The name of the certificate in Azure Key Vault"
  type        = string
}

variable "key_vault_name" {
  description = "The name of the Azure Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group containing the Key Vault"
  type        = string
}

variable "policy_file_path" {
  description = "Path to the certificate policy JSON file"
  type        = string
  default     = "./certificate-policy.json"
}

variable "tags" {
  description = "A map of tags to assign to the certificate"
  type        = map(string)
  default     = {}
}
