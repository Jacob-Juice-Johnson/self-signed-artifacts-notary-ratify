# Simple Certificate Module

Creates a self-signed certificate in Azure Key Vault using a JSON policy file. Follows the exact Microsoft approach from their documentation.

## Usage

```hcl
module "certificate" {
  source = "./modules/certificate"

  certificate_name    = "my-signing-cert"
  key_vault_name      = "my-keyvault"
  resource_group_name = "my-rg"
  policy_file_path    = "./certificate-policy.json"
}
```

## Policy File

Create a `certificate-policy.json` file in your project root:

```json
{
    "issuerParameters": {
        "certificateTransparency": null,
        "name": "Self"
    },
    "keyProperties": {
        "exportable": false,
        "keySize": 2048,
        "keyType": "RSA",
        "reuseKey": true
    },
    "secretProperties": {
        "contentType": "application/x-pem-file"
    },
    "x509CertificateProperties": {
        "ekus": ["1.3.6.1.5.5.7.3.3"],
        "keyUsage": ["digitalSignature"],
        "subject": "CN=my-cert,O=My Org,C=US",
        "validityInMonths": 12
    }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| certificate_name | Certificate name in Key Vault | string | yes |
| key_vault_name | Key Vault name | string | yes |
| resource_group_name | Resource group name | string | yes |
| policy_file_path | Path to policy JSON file | string | no (default: ./certificate-policy.json) |
| tags | Tags for the certificate | map(string) | no |

## Outputs

| Name | Description |
|------|-------------|
| certificate_id | Certificate ID |
| key_id | Key ID for Notation signing |
