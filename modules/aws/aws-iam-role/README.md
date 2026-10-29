# AWS IAM Role Terraform Module

Enterprise-grade Terraform module to create IAM roles supporting AWS service principals, cross-account trust policies, OIDC identity federation (EKS, GitHub Actions), permissions boundaries, and optional instance profile creation.

## Features

- **Multi-Principal Trust**: Easily declare trusted AWS services (`ec2.amazonaws.com`, `lambda.amazonaws.com`) and cross-account ARNs.
- **OIDC Federation Support**: Built-in support for EKS ServiceAccounts and CI/CD pipelines via OIDC providers.
- **Managed & Inline Policies**: Attach standard AWS managed policies via ARNs and custom inline policies via JSON maps.
- **Permissions Boundary Enforcement**: Support enterprise governance by attaching permissions boundary policies.
- **Instance Profile**: Optional creation of an IAM Instance Profile for EC2 deployment.

## Usage Example

### EC2 Service Role Example

```hcl
module "ec2_role" {
  source = "../../modules/aws-iam-role"

  project     = "acme"
  environment = "prod"
  name        = "app-ec2-role"

  trusted_role_services   = ["ec2.amazonaws.com"]
  create_instance_profile = true

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  inline_policies = {
    s3_read_access = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["s3:GetObject", "s3:ListBucket"]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `create` | Controls whether role should be created | `bool` | `true` | no |
| `project` | Project name | `string` | `"enterprise"` | no |
| `environment` | Environment name | `string` | n/a | yes |
| `name` | Role name | `string` | `"role"` | no |
| `trusted_role_services` | Trusted AWS service principals | `list(string)` | `[]` | no |
| `trusted_role_arns` | Trusted ARNs for cross-account assume | `list(string)` | `[]` | no |
| `managed_policy_arns` | List of managed policy ARNs | `list(string)` | `[]` | no |
| `inline_policies` | Map of inline policies | `map(string)` | `{}` | no |
| `create_instance_profile` | Create EC2 Instance Profile | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `iam_role_arn` | ARN of the created IAM role |
| `iam_role_name` | Name of the created IAM role |
| `instance_profile_arn` | ARN of created instance profile |
