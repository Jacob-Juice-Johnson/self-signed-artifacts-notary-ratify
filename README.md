# Container Image Signing Demo with Self-Signed Certificates

Complete Terraform project for demonstrating container image signing using Azure Key Vault, self-signed certificates, and Notation.

## 🏗️ Architecture

This project creates:
- **Resource Group** - Contains all resources
- **Azure Container Registry (ACR)** - Stores container images
- **Azure Key Vault** - Stores the signing certificate  
- **Self-Signed Certificate** - For signing container images
- **Ratify (Optional)** - For Kubernetes admission control

## 🚀 Quick Start

### Prerequisites
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and logged in
- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Notation CLI](https://notaryproject.dev/docs/user-guides/installation/cli/) (for signing images)

### 1. Deploy Infrastructure

```bash
# Clone and navigate to the project
cd self-signed-certificate-with-notary-and-ratify

# Copy and customize variables (optional)
cp terraform.tfvars.example terraform.tfvars

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Deploy
terraform apply
```

### 2. Sign Container Images

After deployment, Terraform will output detailed instructions. Here's the summary:

```bash
# 1. Login to your new ACR
az acr login --name $(terraform output -raw container_registry | jq -r '.name')

# 2. Build and push an image
docker build -t $(terraform output -raw container_registry | jq -r '.login_server')/demo:latest .
docker push $(terraform output -raw container_registry | jq -r '.login_server')/demo:latest

# 3. Sign the image
KEY_ID=$(terraform output -raw certificate | jq -r '.key_id')
IMAGE=$(terraform output -raw container_registry | jq -r '.login_server')/demo:latest
notation sign --signature-format cose --id "$KEY_ID" --plugin azure-kv --plugin-config self_signed=true "$IMAGE"

# 4. Verify the signature
notation verify "$IMAGE"
```

## 📁 Project Structure

```
.
├── main.tf                    # Main Terraform configuration
├── outputs.tf                 # Project outputs with instructions
├── variables.tf              # Optional customization variables
├── terraform.tfvars.example  # Sample variable values
├── certificate-policy.json   # Certificate policy for Key Vault
├── modules/
│   ├── resource-group/       # Simple resource group module
│   ├── acr/                  # Azure Container Registry module
│   ├── keyvault/            # Azure Key Vault module  
│   ├── certificate/         # Self-signed certificate module
│   └── ratify/              # Ratify + Azure Policy module
└── README.md
```

## 🔧 Customization

### Basic Configuration

Edit `terraform.tfvars`:

```hcl
project_name = "my-signing-demo"
location     = "West US 2"
acr_sku      = "Standard"

additional_tags = {
  Owner      = "John Doe"
  CostCenter = "Engineering"
}
```

### Certificate Policy

Edit `certificate-policy.json` to customize the certificate:

```json
{
  "x509CertificateProperties": {
    "subject": "CN=my-company.io,O=My Company,C=US",
    "validityInMonths": 24
  }
}
```

### Enable Ratify (Kubernetes Integration)

Uncomment the Ratify module in `main.tf` and provide your AKS cluster details:

```hcl
module "ratify" {
  source = "./modules/ratify"

  cluster_name        = "my-aks-cluster"
  resource_group_name = "my-aks-rg"
  key_vault_name      = module.key_vault.name
  # ... other configurations
}
```

## 🔐 Security Considerations

⚠️ **Important**: This demo uses self-signed certificates suitable for testing and development only.

For production environments:
- Use certificates from a trusted Certificate Authority
- Implement proper RBAC for Key Vault access
- Enable Key Vault network restrictions
- Use managed identities for authentication
- Implement certificate rotation policies

## 🎯 Use Cases

This project demonstrates:
- **Container Image Signing** - Sign images with Azure Key Vault certificates
- **Supply Chain Security** - Verify image authenticity and integrity  
- **Kubernetes Admission Control** - Use Ratify to block unsigned images
- **DevOps Integration** - Automate signing in CI/CD pipelines

## 📚 References

- [Microsoft Container Signing Documentation](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-tutorial-sign-build-push)
- [Notation Project](https://notaryproject.dev/)
- [Ratify Documentation](https://ratify.dev/)

## 🧹 Cleanup

```bash
# Destroy all resources
terraform destroy
```

## 🤝 Contributing

Feel free to open issues and pull requests to improve this demo project!
