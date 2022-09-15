variable "create" {
  description = "Determines whether resources will be created"
  type        = bool
  default     = true
}

variable "ip_set" {
  description = "A map of interface and/or gateway endpoints containing their properties and configurations"
  type        = any
  default     = {}
}

variable "ip_set_addresses" {
  description = "Default security group IDs to associate with the VPC endpoints"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}


variable "web_acl" {
  description = "A map of interface and/or gateway endpoints containing their properties and configurations"
  type        = any
  default     = {}
}

variable "create_web_acl" {
  description = "Determines whether resources will be created"
  type        = bool
  default     = true
}

variable "default_action" {
  type        = string
  default     = "block"
  description = "Specifies that AWS WAF should allow requests by default. Possible values: `allow`, `block`."
  validation {
    condition     = contains(["allow", "block"], var.default_action)
    error_message = "Allowed values: `allow`, `block`."
  }
}

variable "acl_tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}

variable "acl_name" {
  type = string
  description = "(optional) describe your variable"
  default = ""
}

variable "acl_description" {
  type = string
  description = "(optional) describe your variable"
  default = ""
}

variable "acl_scope" {
  type = string
  description = "(optional) describe your variable"
  default = ""
}

variable "visibility_config" {
  type        = map(string)
  default     = {}
  description = <<-DOC
    Defines and enables Amazon CloudWatch metrics and web request sample collection.
    cloudwatch_metrics_enabled:
      Whether the associated resource sends metrics to CloudWatch.
    metric_name:
      A friendly name of the CloudWatch metric.
    sampled_requests_enabled:
      Whether AWS WAF should store a sampling of the web requests that match the rules.
  DOC
}
