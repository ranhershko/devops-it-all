data "template_file" "app_data" {
  template = file("backends.map.tpl")
  count = length(var.management_apps)
  vars = {
    app_name = element(values(var.management_apps[count.index]), 0)
    domain_name = var.domain_name
  }
}

data "template_file" "backend_cloud_config" {
  template = file("backend_cloud_config.tpl")
  vars = {
    backend_cloud_init = local.backend_cloud_config_userdata
    backend_map = join("", data.template_file.app_data.*.rendered)
  }
}

output "me" {
  value = data.template_file.backend_cloud_config.*.rendered
}
