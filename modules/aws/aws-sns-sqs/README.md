# AWS SNS & SQS Terraform Module (`aws-sns-sqs`)

Production-ready Terraform module for provisioning **Amazon SNS Topics** and **Amazon SQS Queues** with Dead Letter Queues (DLQ), KMS Server-Side Encryption (SSE), and automatic subscription.

---

## Features

- KMS encrypted SNS Topic & SQS Queue.
- Dead Letter Queue (DLQ) with configurable redrive policy (`maxReceiveCount`).
- Automatic SNS-to-SQS subscription and SQS Queue Policy.

---

## Usage Example

```hcl
module "events" {
  source = "../../modules/aws-sns-sqs"

  project     = "enterprise"
  environment = "dev"
  name        = "order-events"

  enable_sns_topic     = true
  enable_sqs_queue     = true
  enable_dlq           = true
  subscribe_sqs_to_sns = true
}
```
