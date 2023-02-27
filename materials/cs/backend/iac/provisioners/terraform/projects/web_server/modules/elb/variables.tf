variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
  default     = []
}

variable "public_sg_id" {
  type        = string
  description = "Public security group ID"
  default     = ""
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
