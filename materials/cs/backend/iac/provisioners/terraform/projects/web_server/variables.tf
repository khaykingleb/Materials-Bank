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

variable "cidr_base" {
  type        = string
  description = "CIDR base value for the VPC"
  default     = "10.10"
}

variable "subnets_count" {
  type        = number
  description = "Number of subnets to create for the VPC"
  default     = 1
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

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ec2_min_size" {
  type        = number
  description = "Minimum number of EC2 instances"
  default     = 2
}

variable "ec2_max_size" {
  type        = number
  description = "Maximum number of EC2 instances"
  default     = 4
}
