variable "environment" {
  type        = string
  description = "Project environment stage"
  default     = ""
}

variable "cidr_base" {
  type        = string
  description = "CIDR base value for the VPC"
  default     = ""
}

variable "subnets_count" {
  type        = number
  description = "Number of subnets to create for the VPC"
  default     = 1
}

variable "tags" {
  type        = map(any)
  description = "Tags to be applied to the resources"
  default     = {}
}
