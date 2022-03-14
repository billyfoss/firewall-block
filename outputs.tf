
output "blocked_cidr_chunks" {
  value = chunklist(local.blocked_cidrs, local.max_cidrs_per_rule)
}

output "project_vpc_list" {
  value = var.project_vpc_map
}

output "firewall_rules" {
  value = local.firewall_rules
}
