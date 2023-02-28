variable "vpc_id" {
  type        = string
  description = "Virtual Private Cloud ID"
  default     = ""
}

variable "ports_to_open" {
  type        = list(number)
  description = "List of ports to open on Internet"
  default     = [80, 443]
}

variable "ssh_ips" {
  type        = list(string)
  description = "List of IPs to allow SSH access"
  default     = []
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to the SSH private key"
  default     = ""
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the SSH public key"
  default     = ""
}

variable "env" {
  type        = string
  description = "Project environment stage"
  default     = ""
}

variable "tags" {
  type        = map(any)
  description = "Tags to be applied to the resources"
  default     = {}
}
