variable "region" {
  type        = string
  description = "Servers location in Amazon's data centers"
  default     = ""
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = ""
}

variable "environment" {
  type        = string
  description = "Project environment stage"
  default     = ""
}

variable "owner" {
  type        = string
  description = "Owner of the project"
  default     = ""
}
