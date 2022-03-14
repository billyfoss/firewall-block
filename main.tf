# Add firewall rules to block traffic from a deny list

locals {
  max_cidrs_per_rule  = 250
  blocked_cidrs       = compact(split("\n", file("${var.deny_list_file}")))
  blocked_cidr_chunks = chunklist(local.blocked_cidrs, local.max_cidrs_per_rule)

  firewall_rules = flatten([
    for project, vpc_list in var.project_vpc_map : [
      for i, pair in setproduct(vpc_list, local.blocked_cidr_chunks) : {
        index     = i,
        project   = project,
        network   = pair[0],
        cidr_list = pair[1],
      }
  ]])
}

resource "google_compute_firewall" "ingress_block" {
  for_each = {
    for fw_rule in local.firewall_rules : "${fw_rule.project}.${fw_rule.network}.${fw_rule.index}" => fw_rule
  }
  name        = "ingress-block-${each.value.index}"
  project     = each.value.project
  network     = each.value.network
  description = "Block ingress from CIDRs in the deny-list"
  deny {
    protocol = "all"
  }
  direction     = "INGRESS"
  source_ranges = each.value.cidr_list
  priority      = var.priority
  disabled      = var.disabled
}

resource "google_compute_firewall" "egress_block" {
  for_each = {
    for fw_rule in local.firewall_rules : "${fw_rule.project}.${fw_rule.network}.${fw_rule.index}" => fw_rule
  }
  name        = "egress-block-${each.value.index}"
  project     = each.value.project
  network     = each.value.network
  description = "Block egress to CIDRs in the deny-list"
  deny {
    protocol = "all"
  }
  direction          = "EGRESS"
  destination_ranges = each.value.cidr_list
  priority           = var.priority
  disabled           = var.disabled
}
