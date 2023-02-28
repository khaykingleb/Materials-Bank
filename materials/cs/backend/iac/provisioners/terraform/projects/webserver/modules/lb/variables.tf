variable "vpc_id" {
  type        = string
  description = "Virtual Private Cloud ID"
  default     = ""
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnets"
  default     = []
}

variable "webserver_lb_sg_id" {
  type        = string
  description = "Webserver load balancer security group ID"
  default     = ""
}

variable "webserver_asg_name" {
  type        = string
  description = "Webserver auto scaling group name"
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
