variable "vpc_id" {
  type        = string
  description = "Virtual Private Cloud ID"
  default     = ""
}

variable "open_ports" {
  type        = list(number)
  description = "List of ports to open on Internet"
  default     = [80, 443]
}

variable "ssh_ips" {
  type        = list(string)
  description = "List of IPs to allow SSH access"
  default     = []
}

variable "environment" {
  type        = string
  description = "Project environment stage"
  default     = ""
}

variable "tags" {
  type        = map(any)
  description = "Tags to be applied to the resources"
  default     = {}
}
