variable "name" {
  description = "The name of the Azure Container Registry"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.name))
    error_message = "ACR name must contain only alphanumeric characters."
  }
}

variable "resource_group_name" {
  description = "The name of the resource group where the ACR will be created"
  type        = string
}

variable "location" {
  description = "The Azure region where the ACR will be created"
  type        = string
}

variable "sku" {
  description = "The SKU of the Azure Container Registry"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard"], var.sku)
    error_message = "SKU must be Basic or Standard for this simple module."
  }
}

variable "admin_enabled" {
  description = "Whether admin user is enabled for the ACR"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Whether public network access is allowed for the ACR"
  type        = bool
  default     = true
}

variable "anonymous_pull_enabled" {
  description = "Whether anonymous pull is enabled"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
