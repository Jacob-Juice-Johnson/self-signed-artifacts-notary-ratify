output "certificate_id" {
  description = "The ID of the certificate in Azure Key Vault"
  value       = data.azurerm_key_vault_certificate.cert.id
}

output "key_id" {
  description = "The Key ID for signing operations (for use with Notation)"
  value       = data.azurerm_key_vault_certificate.cert.versionless_id
}

output "certificate_data" {
  description = "The raw certificate data"
  value       = data.azurerm_key_vault_certificate.cert.certificate_data
  sensitive   = true
}
