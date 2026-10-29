# ECR Repository Resource
resource "aws_ecr_repository" "this" {
  count = var.create ? 1 : 0

  name                 = local.name_prefix
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.encryption_type == "KMS" ? var.kms_key : null
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )
}

# ECR Lifecycle Policy
resource "aws_ecr_lifecycle_policy" "this" {
  count = var.create && var.create_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.this[0].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than ${var.max_untagged_image_age_days} days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = var.max_untagged_image_age_days
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep last ${var.max_tagged_image_count} tagged images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.max_tagged_image_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# Repository Policy for Pull/Push Access
data "aws_iam_policy_document" "this" {
  count = var.create && (length(var.read_access_arns) > 0 || length(var.read_write_access_arns) > 0) ? 1 : 0

  dynamic "statement" {
    for_each = length(var.read_access_arns) > 0 ? [1] : []
    content {
      sid    = "AllowPullAccess"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = var.read_access_arns
      }
      actions = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ]
    }
  }

  dynamic "statement" {
    for_each = length(var.read_write_access_arns) > 0 ? [1] : []
    content {
      sid    = "AllowPushPullAccess"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = var.read_write_access_arns
      }
      actions = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ]
    }
  }
}

resource "aws_ecr_repository_policy" "this" {
  count = var.create && (length(var.read_access_arns) > 0 || length(var.read_write_access_arns) > 0) ? 1 : 0

  repository = aws_ecr_repository.this[0].name
  policy     = data.aws_iam_policy_document.this[0].json
}
