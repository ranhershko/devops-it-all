variable "shared_credentials_file" {
  description = "Terraform user aws credentials_file"
  type        = string
  default     = "/home/ran/.aws/credentials"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Kubernetes project name"
  type        = string
  default     = "devops-it-all"
}

#variable "default_tags" {
  #description = "Default tags for all resources"
  #type        = map
#}

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

variable "management_apps" {
  default = [
    { name = "consul"},
    { name = "jenkins"},
    { name = "vault"},
    { name = "stats"},
  ]
}

variable "domain_name" {
  default = "ranhershko.dns-cloud.net"
}

variable "haproxy_frontend_port" {
  default = 80
}

variable "haproxy_frontend_mode" {
  default = "http"
}

variable "haproxy_socket" {
  default = "/var/lib/haproxy/stats"
}

variable "haproxy_connection_num" {
  default = 10000
}

variable "haproxy_chroot" {
  default = "/var/lib/haproxy"
}

variable "haproxy_user" {
  default = "haproxy"
}

variable "haproxy_group" {
  default = "haproxy"
}

locals {
  cloud_config_write_files_pre = <<-EOT
    #cloud-config
    write_files:
      EOT
}

locals {
  backend_map_config_userdata = <<EOT
  - path: /etc/haproxy/backends.map
    content: |
      EOT
}

locals {
  haproxy_ssl_crt_config_userdata = <<EOT
  - path: /etc/haproxy/ca_bundle.crt
    content: |
      EOT
}
