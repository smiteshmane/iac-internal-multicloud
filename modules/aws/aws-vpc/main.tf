# VPC Resource
resource "aws_vpc" "this" {
  count = var.create ? 1 : 0

  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  count = var.create && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-igw"
    }
  )
}

# Public Subnets
resource "aws_subnet" "public" {
  count = var.create ? length(var.public_subnets) : 0

  vpc_id                  = aws_vpc.this[0].id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = length(var.azs) > count.index ? var.azs[count.index] : null
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    local.merged_tags,
    var.public_subnet_tags,
    {
      "Name" = "${local.name_prefix}-public-${count.index + 1}"
      "Type" = "Public"
    }
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count = var.create ? length(var.private_subnets) : 0

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = length(var.azs) > count.index ? var.azs[count.index] : null

  tags = merge(
    local.merged_tags,
    var.private_subnet_tags,
    {
      "Name" = "${local.name_prefix}-private-${count.index + 1}"
      "Type" = "Private"
    }
  )
}

# Database Subnets
resource "aws_subnet" "database" {
  count = var.create ? length(var.database_subnets) : 0

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = var.database_subnets[count.index]
  availability_zone = length(var.azs) > count.index ? var.azs[count.index] : null

  tags = merge(
    local.merged_tags,
    var.database_subnet_tags,
    {
      "Name" = "${local.name_prefix}-db-${count.index + 1}"
      "Type" = "Database"
    }
  )
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count = local.nat_gateway_count

  domain = "vpc"

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-nat-eip-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

# NAT Gateways
resource "aws_nat_gateway" "this" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-nat-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

# Public Route Table
resource "aws_route_table" "public" {
  count = var.create && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-public-rt"
    }
  )
}

resource "aws_route" "public_internet_gateway" {
  count = var.create && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count = var.create ? length(var.public_subnets) : 0

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

# Private Route Tables
resource "aws_route_table" "private" {
  count = var.create && length(var.private_subnets) > 0 ? (var.single_nat_gateway || !var.enable_nat_gateway ? 1 : local.nat_gateway_count) : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    local.merged_tags,
    {
      "Name" = var.single_nat_gateway || !var.enable_nat_gateway ? "${local.name_prefix}-private-rt" : "${local.name_prefix}-private-rt-${count.index + 1}"
    }
  )
}

resource "aws_route" "private_nat_gateway" {
  count = var.create && var.enable_nat_gateway && length(var.private_subnets) > 0 ? (var.single_nat_gateway ? 1 : local.nat_gateway_count) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "private" {
  count = var.create && length(aws_route_table.private) > 0 ? length(var.private_subnets) : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[var.single_nat_gateway || !var.enable_nat_gateway ? 0 : count.index % local.nat_gateway_count].id
}

# Database Route Table
resource "aws_route_table" "database" {
  count = var.create && length(var.database_subnets) > 0 && var.create_database_subnet_route_table ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-db-rt"
    }
  )
}

resource "aws_route_table_association" "database" {
  count = var.create && length(var.database_subnets) > 0 && var.create_database_subnet_route_table ? length(var.database_subnets) : 0

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database[0].id
}

# VPC Flow Logs
resource "aws_cloudwatch_log_group" "flow_log" {
  count = var.create && var.enable_flow_log && var.flow_log_destination_type == "cloud-watch-logs" ? 1 : 0

  name              = "/aws/vpc-flow-logs/${local.name_prefix}"
  retention_in_days = var.flow_log_retention_in_days

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-flow-logs-lg"
    }
  )
}

resource "aws_iam_role" "flow_log" {
  count = var.create && var.enable_flow_log && var.flow_log_destination_type == "cloud-watch-logs" ? 1 : 0

  name = "${local.name_prefix}-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = local.merged_tags
}

resource "aws_iam_role_policy" "flow_log" {
  count = var.create && var.enable_flow_log && var.flow_log_destination_type == "cloud-watch-logs" ? 1 : 0

  name = "${local.name_prefix}-flow-logs-policy"
  role = aws_iam_role.flow_log[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_flow_log" "this" {
  count = var.create && var.enable_flow_log ? 1 : 0

  traffic_type         = var.flow_log_traffic_type
  vpc_id               = aws_vpc.this[0].id
  log_destination_type = var.flow_log_destination_type
  log_destination      = var.flow_log_destination_type == "cloud-watch-logs" ? aws_cloudwatch_log_group.flow_log[0].arn : null
  iam_role_arn         = var.flow_log_destination_type == "cloud-watch-logs" ? aws_iam_role.flow_log[0].arn : null

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-flow-log"
    }
  )
}

# VPC Endpoints (Gateway Endpoints for S3 & DynamoDB)
resource "aws_vpc_endpoint" "s3" {
  count = var.create && var.enable_s3_endpoint ? 1 : 0

  vpc_id       = aws_vpc.this[0].id
  service_name = "com.amazonaws.${data.aws_region.current.region}.s3"
  route_table_ids = concat(
    aws_route_table.public[*].id,
    aws_route_table.private[*].id,
    aws_route_table.database[*].id
  )

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-s3-endpoint"
    }
  )
}

resource "aws_vpc_endpoint" "dynamodb" {
  count = var.create && var.enable_dynamodb_endpoint ? 1 : 0

  vpc_id       = aws_vpc.this[0].id
  service_name = "com.amazonaws.${data.aws_region.current.region}.dynamodb"
  route_table_ids = concat(
    aws_route_table.public[*].id,
    aws_route_table.private[*].id,
    aws_route_table.database[*].id
  )

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-dynamodb-endpoint"
    }
  )
}

data "aws_region" "current" {}
