variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "devops-assignment"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.20.0.0/16"
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "devopsdb"
}

variable "db_username" {
  description = "PostgreSQL username"
  type        = string
  default     = "devops"
}

variable "db_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key installed on EC2"
  type        = string
}

variable "ssh_ingress_cidr" {
  description = "CIDR allowed to SSH to EC2"
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
