# Variables

variable "project_vpc_map" {
  description = "Map of project and VPCs to update"
  default     = {}
  type        = map(list(string))
  /* Example
    project_vpc_map = {
        "test-project-1" = [ "vpc1", "vpc2" ]
        "test-project-2" = [ "vpc1", "vpc2" ]
    }
    */
}

variable "deny_list_file" {
  description = "File with a list of CIDRs to deny"
  default     = "./deny-list.txt"
  type        = string
}

variable "priority" {
  description = "Priority for these rules"
  default     = 0
  type        = number
}

variable "disabled" {
  description = "Whether firewall rules are disabled"
  default     = false
  type        = bool
}
