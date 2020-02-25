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

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map
}

variable "haproxy_instance_type" {
  description = "haproxy type & size"
  type        = string
  default     = "t2.micro"
}

variable "haproxy_scale_size" {
  description = "haproxy scale size"
  type        = number
  default     = 1
}

