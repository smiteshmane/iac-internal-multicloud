output "state_machine_arn" {
  description = "The ARN of the Step Functions State Machine"
  value       = try(aws_sfn_state_machine.this[0].arn, "")
}

output "state_machine_id" {
  description = "The ID of the Step Functions State Machine"
  value       = try(aws_sfn_state_machine.this[0].id, "")
}

output "role_arn" {
  description = "The ARN of the IAM Role assigned to the State Machine"
  value       = try(aws_iam_role.this[0].arn, "")
}
