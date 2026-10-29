output "id" {
  description = "The ID of the instance"
  value       = var.create_spot_instance ? try(aws_spot_instance_request.this[0].spot_instance_id, "") : try(aws_instance.this[0].id, "")
}

output "arn" {
  description = "The ARN of the instance"
  value       = var.create_spot_instance ? try(aws_spot_instance_request.this[0].arn, "") : try(aws_instance.this[0].arn, "")
}

output "private_ip" {
  description = "The private IP address assigned to the instance"
  value       = var.create_spot_instance ? try(aws_spot_instance_request.this[0].private_ip, "") : try(aws_instance.this[0].private_ip, "")
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable"
  value       = var.create_spot_instance ? try(aws_spot_instance_request.this[0].public_ip, "") : try(aws_instance.this[0].public_ip, "")
}

output "private_dns" {
  description = "The private DNS name assigned to the instance"
  value       = var.create_spot_instance ? try(aws_spot_instance_request.this[0].private_dns, "") : try(aws_instance.this[0].private_dns, "")
}

output "spot_request_id" {
  description = "The ID of the Spot Instance Request (if create_spot_instance is true)"
  value       = try(aws_spot_instance_request.this[0].id, "")
}
