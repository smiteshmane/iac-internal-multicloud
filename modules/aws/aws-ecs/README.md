# AWS ECS Fargate Terraform Module

Enterprise-grade Terraform module to provision Amazon ECS Clusters, Fargate Task Definitions, CloudWatch Container Log Groups, and Fargate Services with ALB target group integration and private subnet network placement.

## Features

- **Fargate Serverless Compute**: Configurable with Fargate & FARGATE_SPOT capacity providers.
- **Private Network Placement**: Enforces `assign_public_ip = false` when deployed in private subnets behind an ALB.
- **Container Insights & Logging**: Enables Container Insights on the cluster and provisions CloudWatch log groups streaming container stdout/stderr.
- **Load Balancer Integration**: Automatic target group attachment for zero-downtime rolling deployments.

## Usage Example

```hcl
module "ecs" {
  source = "../../modules/aws-ecs"

  project     = "acme"
  environment = "dev"
  name        = "nginx-app"

  container_image = "public.ecr.aws/nginx/nginx:latest"
  container_port  = 80
  desired_count   = 2

  subnet_ids         = ["subnet-private-1", "subnet-private-2"]
  security_group_ids = ["sg-ecs-private"]
  target_group_arn   = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/web-tg/abc"
  execution_role_arn = "arn:aws:iam::123456789012:role/acme-dev-ecs-execution-role"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `create` | Controls whether ECS resources are created | `bool` | `true` | no |
| `project` | Project name | `string` | `"enterprise"` | no |
| `environment` | Deployment environment | `string` | n/a | yes |
| `name` | Resource name | `string` | `"app"` | no |
| `container_image` | Docker image | `string` | `"public.ecr.aws/nginx/nginx:latest"` | no |
| `container_port` | Exposed container port | `number` | `80` | no |
| `desired_count` | Number of tasks | `number` | `2` | no |
| `subnet_ids` | Private Subnet IDs | `list(string)` | `[]` | yes |
| `security_group_ids` | Security Group IDs | `list(string)` | `[]` | yes |

## Outputs

| Name | Description |
|------|-------------|
| `cluster_id` | ECS Cluster ID |
| `cluster_arn` | ECS Cluster ARN |
| `service_name` | ECS Service Name |
| `task_definition_arn` | Task Definition ARN |
