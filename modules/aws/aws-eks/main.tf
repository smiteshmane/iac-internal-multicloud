# IAM Role for EKS Cluster Control Plane
resource "aws_iam_role" "cluster" {
  count = var.create ? 1 : 0

  name = "${local.name_prefix}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = local.merged_tags
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  count = var.create ? 1 : 0

  role       = aws_iam_role.cluster[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# EKS Cluster Resource
resource "aws_eks_cluster" "this" {
  count = var.create ? 1 : 0

  name     = local.name_prefix
  version  = var.kubernetes_version
  role_arn = aws_iam_role.cluster[0].arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy
  ]
}

# IAM Role for EKS Node Group
resource "aws_iam_role" "node_group" {
  count = var.create ? 1 : 0

  name = "${local.name_prefix}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.merged_tags
}

resource "aws_iam_role_policy_attachment" "node_worker" {
  count = var.create ? 1 : 0

  role       = aws_iam_role.node_group[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_cni" {
  count = var.create ? 1 : 0

  role       = aws_iam_role.node_group[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_ecr" {
  count = var.create ? 1 : 0

  role       = aws_iam_role.node_group[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# EKS Managed Node Group
resource "aws_eks_node_group" "this" {
  count = var.create ? 1 : 0

  cluster_name    = aws_eks_cluster.this[0].name
  node_group_name = "${local.name_prefix}-ng"
  node_role_arn   = aws_iam_role.node_group[0].arn
  subnet_ids      = var.subnet_ids

  instance_types = var.instance_types
  capacity_type  = var.capacity_type

  scaling_config {
    desired_size = var.node_group_desired_size
    min_size     = var.node_group_min_size
    max_size     = var.node_group_max_size
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-ng"
    }
  )

  depends_on = [
    aws_iam_role_policy_attachment.node_worker,
    aws_iam_role_policy_attachment.node_cni,
    aws_iam_role_policy_attachment.node_ecr
  ]
}
