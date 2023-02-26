variable "webserver_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
  default     = []
}

variable "webserver_sg_id" {
  type        = string
  description = "Web security group ID"
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
