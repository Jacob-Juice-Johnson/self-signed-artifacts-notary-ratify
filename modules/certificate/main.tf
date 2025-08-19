# main.tf - Use Azure CLI directly with JSON policy file

# Create certificate using Azure CLI with JSON policy file (exact Microsoft approach)
resource "null_resource" "create_certificate" {
  provisioner "local-exec" {
    command = "az keyvault certificate create -n ${var.certificate_name} --vault-name ${var.key_vault_name} -p @${var.policy_file_path}"
  }

  # Trigger recreation if policy file changes or key parameters change
  triggers = {
    policy_hash = filemd5(var.policy_file_path)
    cert_name   = var.certificate_name
    vault_name  = var.key_vault_name
  }
}
