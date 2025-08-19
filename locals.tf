locals {
  project_name = "notary-ratify-demo"
  location     = "East US"
  
  common_tags = {
    Project     = "Container Image Signing Demo"
    Environment = "Demo"
    Purpose     = "Self-Signed Certificate with Notary and Ratify"
    ManagedBy   = "Terraform"
  }
}