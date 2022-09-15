module "waf" {
    source = "P:/COMPUTER STUFF/Terraform/how-to/modules/tf-waf"
    
    ip_set = {

    set1 = {
        name = "set1"
        description = "ip set for ip_set1"
        scope = "REGIONAL"
        ip_address_version = "IPV4"
        ip_set_addresses = ["139.180.248.0/24", "139.180.248.0/32", "208.127.0.0/16", "66.159.192.0/24"]
        tags = { Name = "set1"}
            }

    set2 = {
        name = "set2"
        description = "ip set for ip_set2"
        scope = "REGIONAL"
        ip_address_version = "IPV4"
        ip_set_addresses = ["130.41.0.0/24", "134.238.168.0/24", "137.83.192.0/24"]
        tags = { Name = "set2"}
            }
    }



    web_acl = {
        acl_name = "vault"
        acl_description = "acl for vault"
        acl_scope = "REGIONAL"
        default_action = "block"

    vault = [
    {
        name = "rule-1"
        action = "block"
        priority = 1

        statement = {
            ip_set_reference_statement = ""
        }

        visibility_config = {
            cloudwatch_metrics_enabled = false
            sampled_requests_enabled = false
            metric_name = "rule-1-metric"
        }
    }
    ]

    }
}
