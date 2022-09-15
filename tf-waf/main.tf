locals {
  ip_set = {for k, v in var.ip_set : k => v if var.create && try(v.create, true)}
  web_acl = {for k, v in var.web_acl : k => v if var.create_web_acl && try(v.create_web_acl, true)}
}



resource "aws_wafv2_ip_set" "this" {
  for_each = local.ip_set
  name               = lookup(each.value, "name", null)
  description        = lookup(each.value, "description", null )
  scope              = lookup(each.value, "scope", "REGIONAL")
  ip_address_version = lookup(each.value, "ip_address_version", "IPV4")
  
  addresses          = lookup(each.value, "ip_address_version", "IPV4") == "IPV4" ? distinct(concat(var.ip_set_addresses, lookup(each.value, "ip_set_addresses", []))) : null

  tags = merge(var.tags, lookup(each.value, "tags", {}))

}

resource "aws_wafv2_web_acl" "this" {
  for_each = local.web_acl
  name        = var.acl_name #lookup(each.value, "name", null)
  description = var.acl_description #lookup(each.value, "description", null )
  scope       = var.acl_scope #lookup(each.value, "scope", "REGIONAL")

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
      }

    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }
  
  visibility_config {
    cloudwatch_metrics_enabled = lookup(var.visibility_config, "cloudwatch_metrics_enabled", false)
    metric_name                = lookup(var.visibility_config, "metric_name", false)
    sampled_requests_enabled   = lookup(var.visibility_config, "sampled_requests_enabled", false)
  }

  dynamic "rule" {
    for_each = local.web_acl
    content {
      name = rule.value.name
      priority = rule.value.priority
    

    action {
      dynamic "allow" {
        for_each = rule.value.action == "allow" ? [1] : []

        content {}
      }

      dynamic "block" {
        for_each = rule.value.action == "block" ? [1] : []

        content {}
      }
    }
    

    statement {
      dynamic "ip_set_reference_statement" {
        for_each = lookup(rule.value, "statement", null) != null ? [rule.value.statement] : []
        
        content {
          arn = ip_set_reference_statement.value.arn
        } #arn = aws_wafv2_ip_set.this[*].arn
      }
    }

    dynamic "visibility_config" {
      for_each = lookup(rule.value, "visibility_config", null) != null ? [rule.value.visibility_config] : []

      content {
        cloudwatch_metrics_enabled = lookup(visibility_config.value, "cloudwatch_metrics_enabled", "false")
        metric_name = visibility_config.value.metric_name
        sampled_requests_enabled = lookup(visibility_config.value, "sampled_requests_enabled", "false")
      }

    }

  }
  }  
  tags = merge(var.acl_tags, lookup(each.value, "tags", {}))
}
