# MSK Cluster Resource
resource "aws_msk_cluster" "this" {
  count = var.create ? 1 : 0

  cluster_name           = local.name_prefix
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes

  broker_node_group_info {
    instance_type   = var.instance_type
    client_subnets  = var.client_subnets
    security_groups = var.security_groups

    storage_info {
      ebs_storage_info {
        volume_size = var.ebs_volume_size
      }
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )
}
