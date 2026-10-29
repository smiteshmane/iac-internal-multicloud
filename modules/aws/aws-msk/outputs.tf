output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of the MSK Cluster"
  value       = try(aws_msk_cluster.this[0].arn, "")
}

output "cluster_name" {
  description = "Name of the MSK Cluster"
  value       = try(aws_msk_cluster.this[0].cluster_name, "")
}

output "bootstrap_brokers_tls" {
  description = "A comma separated list of one or more hostname:port pairs of TLS enabled brokers"
  value       = try(aws_msk_cluster.this[0].bootstrap_brokers_tls, "")
}

output "zookeeper_connect_string" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache ZooKeeper cluster"
  value       = try(aws_msk_cluster.this[0].zookeeper_connect_string, "")
}
