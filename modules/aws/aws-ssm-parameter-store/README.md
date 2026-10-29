# AWS SSM Parameter Store Terraform Module (`aws-ssm-parameter-store`)

Production-ready Terraform module for provisioning **AWS Systems Manager (SSM) Parameters** (`String`, `StringList`, and `SecureString` with KMS encryption).

---

## Usage Example

```hcl
module "ssm_param" {
  source = "../../modules/aws-ssm-parameter-store"

  project     = "enterprise"
  environment = "dev"
  name        = "db_password"

  type  = "SecureString"
  value = "SuperSecretPassword123!"
}
```
