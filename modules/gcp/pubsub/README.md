# GCP Cloud Pub/Sub Terraform Module

Production-ready Terraform module for provisioning Google Cloud Pub/Sub topics, pull/push subscriptions, dead-letter queues (DLQ), message retention policies, CMEK encryption, and publisher/subscriber IAM bindings.

## Features
- **Event Messaging**: Production topics with pull, push, or HTTP webhook subscriptions.
- **Dead-Letter Queues (DLQ)**: Automatic message retry and dead-letter topic routing.
- **CMEK Encryption**: Optional Cloud KMS Customer-Managed Encryption Key support.
- **IAM Security**: Fine-grained `roles/pubsub.publisher` and `roles/pubsub.subscriber` bindings.

## Usage Example

```hcl
module "order_events" {
  source = "./modules/pubsub"

  topic_name = "prod-order-events"
  project_id = "my-gcp-project-123456"

  subscriptions = [
    {
      name                  = "order-processing-sub"
      ack_deadline_seconds  = 30
      max_delivery_attempts = 5
      dead_letter_topic     = "projects/my-gcp-project-123456/topics/prod-order-events-dlq"
    }
  ]

  publishers = [
    "serviceAccount:order-api-sa@my-gcp-project-123456.iam.gserviceaccount.com"
  ]

  subscribers = [
    "serviceAccount:payment-worker-sa@my-gcp-project-123456.iam.gserviceaccount.com"
  ]

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}
```
