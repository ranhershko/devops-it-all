variable "shared_credentials_file" {
  description = "Terraform user aws credentials_file"
  type        = string
  default     = "/home/ran/.aws/credentials"
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "project_name" {
  description = "Kubernetes project name"
  type        = string
}

variable "aws_vpc_cidr_block" {
  description = "CIDR Block for VPC"
  type        = string
}

variable "aws_private_subnets_cidr" {
  description = "CIDR Blocks for private subnets"
  type        = list
}

variable "aws_public_subnets_cidr" {
  description = "CIDR Blocks for public subnets"
  type        = list
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map
}

variable "worker_instance_type" {
  description = "Kubernetes worker type & size"
  type        = string
}

variable "first_time_create" {
  description = "Variable sign for remote state creation"
  type        = bool
}
