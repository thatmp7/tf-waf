locals {
  ip_set = {for k, v in var.ip_set : k => v if var.create && try(v.create, true)}

}



resource "aws_wafv2_ip_set" "this" {
    for_each = local.ip_set
  name               = lookup(each.value, "name", "ip_set_name")
  description        = lookup(each.value, "description", "ip_set_description" )
  scope              = lookup(each.value, "scope", "REGIONAL")
  ip_address_version = lookup(each.value, "ip_address_version", "IPV4")
  
  addresses          = lookup(each.value, "ip_address_version", "IPV4") == "IPV4" ? distint(concat(var.ip_set_addresses, lookup(each.value, "ip_set_addresses", []))) : null

  tags = merge(var.tags, lookup(each.value, "tags", {}))

}
/*
resource "aws_wafv2_web_acl" "example" {
  name        = "vault_web-acl"
  description = "Example of a Regional ipset statement."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    action {
      allow {}
    }

    statement {

      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.example.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "rule-1"
      sampled_requests_enabled   = false
    }

  }

  tags = {
    application = "vault"
    component   = "vault_web-acl"
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}*/