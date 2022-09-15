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

"130.41.0.0/24", "134.238.168.0/24", "137.83.192.0/24", "139.180.248.0/24", "139.180.248.0/32", "208.127.0.0/16", "66.159.192.0/24"
