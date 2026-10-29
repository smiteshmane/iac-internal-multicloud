# AWS EKS Terraform Module (`aws-eks`)

Production-ready Terraform module for provisioning **Amazon EKS (Elastic Kubernetes Service)** Control Planes and EKS Managed Node Groups.

---

## Features

- Dynamic IAM Role creation for Cluster Control Plane & Worker Nodes.
- EKS Managed Node Groups with auto-scaling configuration.
- Support for `ON_DEMAND` and `SPOT` instance capacity types.
- Pre-configured IAM policy attachments (WorkerNode, CNI, ECRReadOnly).

---

## Usage Example

```hcl
module "eks" {
  source = "../../modules/aws-eks"

  project     = "enterprise"
  environment = "dev"
  name        = "k8s-cluster"

  kubernetes_version     = "1.30"
  subnet_ids             = module.vpc.private_subnets
  instance_types         = ["t3.medium"]
  node_group_desired_size = 2
  node_group_min_size     = 1
  node_group_max_size     = 4
}
```
