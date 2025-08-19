# outputs.tf - Main project outputs

# Resource Group outputs
output "resource_group" {
  description = "Resource group information"
  value = {
    id       = module.resource_group.id
    name     = module.resource_group.name
    location = module.resource_group.location
  }
}

# Azure Container Registry outputs
output "container_registry" {
  description = "Azure Container Registry information"
  value = {
    id           = module.acr.id
    name         = module.acr.name
    login_server = module.acr.login_server
  }
}

# Key Vault outputs
output "key_vault" {
  description = "Azure Key Vault information"
  value = {
    id   = module.key_vault.id
    name = module.key_vault.name
  }
}

# Certificate outputs
output "certificate" {
  description = "Certificate information for container signing"
  value = {
    id     = module.certificate.certificate_id
    key_id = module.certificate.key_id
  }
}

# AKS outputs
output "aks_cluster" {
  description = "AKS cluster information"
  value = {
    id          = module.aks.id
    name        = module.aks.name
    fqdn        = module.aks.fqdn
    principal_id = module.aks.principal_id
  }
}

# Instructions for next steps
output "next_steps" {
  description = "Instructions for using the created resources"
  value = <<-EOT
    
    🎉 Your container image signing demo environment is ready!
    
    📋 Created Resources:
    • Resource Group: ${module.resource_group.name}
    • Container Registry: ${module.acr.login_server}
    • Key Vault: ${module.key_vault.name}
    • Certificate: container-signing-cert
    • AKS Cluster: ${module.aks.name}
    
    🚀 Next Steps:
    
    1. Get AKS credentials:
       az aks get-credentials --resource-group ${module.resource_group.name} --name ${module.aks.name}
    
    2. Login to ACR:
       az acr login --name ${module.acr.name}
    
    3. Build and push an image:
       docker build -t ${module.acr.login_server}/demo:latest .
       docker push ${module.acr.login_server}/demo:latest
    
    4. Sign the image with Notation:
       notation sign --signature-format cose --id "${module.certificate.key_id}" --plugin azure-kv --plugin-config self_signed=true ${module.acr.login_server}/demo:latest
    
    5. Download certificate for verification:
       az keyvault certificate download --vault-name "${module.key_vault.name}" --name "container-signing-cert" --file cert.pem
    
    6. Verify the signed image:
       notation verify ${module.acr.login_server}/demo:latest
    
    7. Deploy Ratify to AKS (uncomment ratify module in main.tf):
       kubectl apply -f ratify-config.yaml
    
    📚 For Ratify deployment, uncomment the ratify module in main.tf to enable admission control.
    
  EOT
}

# Sensitive outputs (use terraform output -raw to view)
output "certificate_data" {
  description = "Certificate data (use: terraform output -raw certificate_data > cert.pem)"
  value       = module.certificate.certificate_data
  sensitive   = true
}
