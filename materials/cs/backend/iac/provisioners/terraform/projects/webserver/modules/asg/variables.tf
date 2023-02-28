variable "public_subnets" {
  type        = list(string)
  description = "List of public subnets"
  default     = []
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ec2_user_data_path" {
  type        = string
  description = "EC2 user data path"
  default     = ""
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

variable "ec2_desired_capacity" {
  type        = number
  description = "Desired number of EC2 instances"
  default     = 2
}

variable "ec2_instance_sg_id" {
  type        = string
  description = "Webserver EC2 instance security group ID"
  default     = ""
}

variable "openssh_public_key" {
  type        = string
  description = "OpenSSH public key"
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
