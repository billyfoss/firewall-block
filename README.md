# GCP Firewall automation to block large sets fo IP ranges

This code is designed to take a list of IP CIDR ranges and 
create firewall rules that will block traffic from these 
IP ranges and traffic to these ranges.

When list of CIDR raanges get long, this will split the list
into 250 CIDRs per firewall rule.
