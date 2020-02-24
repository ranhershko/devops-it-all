variable "project_name" {
  description = "Kubernetes project name"
  type        = string
}

variable "aws_vpc_cidr_block" {
  description = "AWS VPC CIDR"
  type        = string
}

variable "aws_avail_zones" {
  description = "AWS Availability Zones"
  type        = list
}

variable "aws_private_subnets_cidr" {
  description = "Private subnets CIDR Blocks"
  type        = list
}

variable "aws_public_subnets_cidr" {
  description = "Public subnets CIDR Blocks"
  type        = list
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map
}

variable "internet_default_route_cidr" {
  description = "Internet default route cidr"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh_port" {
  description = "ssh service port"
  type        = number
  default     = 22
}