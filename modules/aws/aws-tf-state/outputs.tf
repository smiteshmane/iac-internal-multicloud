output "s3_bucket_id" {
  description = "Name of the S3 bucket created for Terraform state storage"
  value       = try(aws_s3_bucket.this[0].id, "")
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket created for Terraform state storage"
  value       = try(aws_s3_bucket.this[0].arn, "")
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table created for Terraform state locking"
  value       = try(aws_dynamodb_table.locks[0].name, "")
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table created for Terraform state locking"
  value       = try(aws_dynamodb_table.locks[0].arn, "")
}

output "backend_config" {
  description = "Suggested HCL terraform backend block code snippet"
  value = var.create ? format(
    <<-EOF
    terraform {
      backend "s3" {
        bucket         = "%s"
        key            = "global/s3/terraform.tfstate"
        region         = "us-east-1"
        dynamodb_table = "%s"
        encrypt        = true
      }
    }
    EOF
    ,
    try(aws_s3_bucket.this[0].id, ""),
    try(aws_dynamodb_table.locks[0].name, "")
  ) : ""
}
