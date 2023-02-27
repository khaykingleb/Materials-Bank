variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
  default     = []
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
  default     = []
}

variable "public_sg_id" {
  type        = string
  description = "Public security group ID"
  default     = ""
}

variable "private_sg_id" {
  type        = string
  description = "Private security group ID"
  default     = ""
}

variable "ssh_key" {
  type        = string
  description = "OpenSSH public key"
  default     = ""
}

variable "elb_name" {
  type        = string
  description = "Elastic Load Balancer name"
  default     = ""
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ec2_min_size" {
  type        = number
  description = "EC2 minimum size"
  default     = 2
}

variable "ec2_max_size" {
  type        = number
  description = "EC2 maximum size"
  default     = 4
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
