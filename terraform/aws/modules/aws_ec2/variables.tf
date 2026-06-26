variable "name" {
  type        = string
  default     = "ec2-instance"
  description = "Name prefix for EC2 resources."
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type."
}

variable "instance_count" {
  type        = number
  default     = 1
  description = "Number of EC2 instances to create."
}

variable "ami" {
  type        = string
  default     = ""
  description = "AMI ID to use for the EC2 instance. If empty, the latest Amazon Linux 2 AMI is selected."
}

variable "key_name" {
  type        = string
  default     = ""
  description = "Optional EC2 key pair name for SSH access."
}

variable "subnet_id" {
  type        = string
  default     = ""
  description = "Optional subnet ID for the EC2 instance. If empty, AWS will choose a default subnet."
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "Optional VPC ID for the security group. If empty, the default VPC is used."
}

variable "allowed_ssh_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR range allowed to connect to the instance over SSH."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to apply to EC2 resources."
}