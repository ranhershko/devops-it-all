locals {
  cloud_config_write_files_pre = <<-EOT
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
  - path: /etc/ssl/ca_bundle.crt
    content: |
      EOT
}
