variable "account_name" {
  description = "The name of the Cosmos DB Account (globally unique)."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "The Resource Group name."
  type        = string
}

variable "kind" {
  description = "Kind of Cosmos DB Account: GlobalDocumentDB, MongoDB, Parse."
  type        = string
  default     = "GlobalDocumentDB"
}

variable "enable_automatic_failover" {
  description = "Enable automatic failover across geo-replication locations."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Allow or disallow public network access."
  type        = bool
  default     = true
}

variable "consistency_level" {
  description = "Consistency level: Eventual, ConsistentPrefix, Session, BoundedStaleness, Strong."
  type        = string
  default     = "Session"
}

variable "max_interval_in_seconds" {
  description = "Max lag time for BoundedStaleness."
  type        = number
  default     = 5
}

variable "max_staleness_prefix" {
  description = "Max stale requests for BoundedStaleness."
  type        = number
  default     = 100
}

variable "geo_locations" {
  description = "List of geo-location failover regions."
  type = list(object({
    location          = string
    failover_priority = number
    zone_redundant    = optional(bool, false)
  }))
}

variable "sql_database_name" {
  description = "Optional SQL Database name to create inside the Cosmos Account."
  type        = string
  default     = null
}

variable "sql_database_throughput" {
  description = "Throughput (RU/s) for SQL Database."
  type        = number
  default     = 400
}

variable "sql_containers" {
  description = "Map of SQL containers: key=name, value={partition_key_path, throughput}"
  type = map(object({
    partition_key_path = string
    throughput         = optional(number)
  }))
  default = {}
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
