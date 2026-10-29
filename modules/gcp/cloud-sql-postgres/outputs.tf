output "instance_name" {
  description = "The name of the Cloud SQL PostgreSQL instance."
  value       = google_sql_database_instance.instance.name
}

output "instance_connection_name" {
  description = "The connection name of the Cloud SQL instance to be used in connection strings (project:region:instance)."
  value       = google_sql_database_instance.instance.connection_name
}

output "private_ip_address" {
  description = "The private IP address allocated to the Cloud SQL instance."
  value       = google_sql_database_instance.instance.private_ip_address
}

output "public_ip_address" {
  description = "The public IP address allocated to the Cloud SQL instance (if enabled)."
  value       = google_sql_database_instance.instance.public_ip_address
}

output "database_name" {
  description = "The name of the created default database."
  value       = google_sql_database.db.name
}

output "database_user" {
  description = "The database user name."
  value       = google_sql_user.user.name
}
