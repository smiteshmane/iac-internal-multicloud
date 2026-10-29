# Application Load Balancer
resource "aws_lb" "this" {
  count = var.create ? 1 : 0

  name                       = local.name_prefix
  internal                   = var.internal
  load_balancer_type         = var.load_balancer_type
  security_groups            = var.security_groups
  subnets                    = var.subnets
  enable_deletion_protection = var.enable_deletion_protection
  drop_invalid_header_fields = var.drop_invalid_header_fields

  dynamic "access_logs" {
    for_each = var.access_logs.enabled ? [1] : []
    content {
      bucket  = var.access_logs.bucket
      prefix  = var.access_logs.prefix
      enabled = true
    }
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = local.name_prefix
    }
  )
}

# Target Groups
resource "aws_lb_target_group" "this" {
  for_each = var.create ? var.target_groups : {}

  name                 = try(each.value.name, substr("${local.name_prefix}-${each.key}", 0, 32))
  port                 = each.value.backend_port
  protocol             = each.value.backend_protocol
  vpc_id               = data.aws_subnet.selected[0].vpc_id
  target_type          = each.value.target_type
  deregistration_delay = each.value.deregistration_delay

  health_check {
    enabled             = try(each.value.health_check.enabled, true)
    path                = try(each.value.health_check.path, "/")
    port                = try(each.value.health_check.port, "traffic-port")
    protocol            = try(each.value.health_check.protocol, "HTTP")
    healthy_threshold   = try(each.value.health_check.healthy_threshold, 3)
    unhealthy_threshold = try(each.value.health_check.unhealthy_threshold, 3)
    timeout             = try(each.value.health_check.timeout, 5)
    interval            = try(each.value.health_check.interval, 30)
    matcher             = try(each.value.health_check.matcher, "200-399")
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-${each.key}-tg"
    }
  )
}

# Subnet Data Lookup for VPC ID
data "aws_subnet" "selected" {
  count = var.create && length(var.subnets) > 0 ? 1 : 0
  id    = var.subnets[0]
}

# HTTP Listeners (with automatic HTTP to HTTPS redirect support)
resource "aws_lb_listener" "http" {
  count = var.create ? length(var.http_tcp_listeners) : 0

  load_balancer_arn = aws_lb.this[0].arn
  port              = var.http_tcp_listeners[count.index].port
  protocol          = var.http_tcp_listeners[count.index].protocol

  dynamic "default_action" {
    for_each = var.http_tcp_listeners[count.index].redirect_to_https ? [1] : []
    content {
      type = "redirect"
      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  dynamic "default_action" {
    for_each = !var.http_tcp_listeners[count.index].redirect_to_https ? [1] : []
    content {
      type             = "forward"
      target_group_arn = aws_lb_target_group.this[var.http_tcp_listeners[count.index].target_group_key].arn
    }
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-http-${var.http_tcp_listeners[count.index].port}"
    }
  )
}

# HTTPS Listeners
resource "aws_lb_listener" "https" {
  count = var.create ? length(var.https_listeners) : 0

  load_balancer_arn = aws_lb.this[0].arn
  port              = var.https_listeners[count.index].port
  protocol          = "HTTPS"
  ssl_policy        = var.https_listeners[count.index].ssl_policy
  certificate_arn   = var.https_listeners[count.index].certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[var.https_listeners[count.index].target_group_key].arn
  }

  tags = merge(
    local.merged_tags,
    {
      "Name" = "${local.name_prefix}-https-${var.https_listeners[count.index].port}"
    }
  )
}

# WAF v2 Web ACL Association
resource "aws_wafv2_web_acl_association" "this" {
  count = var.create && var.waf_web_acl_arn != null ? 1 : 0

  resource_arn = aws_lb.this[0].arn
  web_acl_arn  = var.waf_web_acl_arn
}
