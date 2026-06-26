variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "freetrial"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type for the freetrial environment"
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "EC2 instance count for the freetrial environment"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Default tags applied to resources"
  type        = map(string)
  default = {
    Environment = "freetrial"
    Project     = "aws-saa-practice"
  }
}
