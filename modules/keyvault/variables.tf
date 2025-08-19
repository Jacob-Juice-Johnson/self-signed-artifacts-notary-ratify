variable "name" {
  description = "The name of the Azure Key Vault"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,24}$", var.name))
    error_message = "Key Vault name must be 3-24 characters long and contain only alphanumeric characters and hyphens."
  }
}

variable "location" {
  description = "The Azure region where the Key Vault will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Key Vault will be created"
  type        = string
}

variable "sku_name" {
  description = "The SKU of the Azure Key Vault"
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "SKU must be either 'standard' or 'premium'."
  }
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the Key Vault"
  type        = bool
  default     = true
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled (set to false for demo to allow deletion)"
  type        = bool
  default     = false
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain deleted keys, secrets, and certificates"
  type        = number
  default     = 7
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Soft delete retention days must be between 7 and 90."
  }
}

variable "additional_access_policies" {
  description = "Additional access policies for the Key Vault"
  type = map(object({
    object_id                = string
    certificate_permissions = list(string)
    key_permissions         = list(string)
    secret_permissions      = list(string)
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
