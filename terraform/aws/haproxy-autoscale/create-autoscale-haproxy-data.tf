data "terraform_remote_state" "vpc-n-eks" {
  backend = "s3"
  config = {
    bucket = "devopsitall-terraform-remote-state"
    key    = "vpc-n-eks-terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "devops-it-all-consulNhaproxy-AMI" {
  owners      = ["self"]
  most_recent = true

  filter {
    name   = "tag:Name"
    values = ["devops-it-all-consulNhaproxy-AMI*"]
  }
}

data "aws_eip" "haproxy" {
  tags = {
    Name = "haproxy_scale_eip"
  }
}

data "http" "myip" {
  url = "http://api.ipify.org/"
}

data "template_file" "haproxy_cfg_config_write_files" {
  template = file("template/haproxy.cfg.tpl")
  vars = {
    haproxy_frontend_port      = var.haproxy_frontend_port
    haproxy_frontend_mode      = var.haproxy_frontend_mode
    haproxy_socket             = var.haproxy_socket
    haproxy_connection_num     = var.haproxy_connection_num
    haproxy_chroot             = var.haproxy_chroot
    haproxy_user               = var.haproxy_user
    haproxy_group              = var.haproxy_group
    management_server_ip       = chomp(data.http.myip.body)
    domain_name                = var.domain_name
    nat_a_public_ip            = chomp(data.terraform_remote_state.vpc-n-eks.outputs.aws_vpc_nat_public_ips[0]) 
    nat_b_public_ip            = chomp(data.terraform_remote_state.vpc-n-eks.outputs.aws_vpc_nat_public_ips[1])
    nat_c_public_ip            = chomp(data.terraform_remote_state.vpc-n-eks.outputs.aws_vpc_nat_public_ips[2])
  }
}

data "template_file" "backends_map_config" {
  template = file("template/backends.map.tpl")
  count = length(var.management_apps)
  vars = {
    app_name = element(values(var.management_apps[count.index]), 0)
    domain_name = var.domain_name
  }
}

data "template_file" "backends_map_config_write_files" {
  template = file("template/backends_map_config_write_files.tpl")
  vars = {
    backends_map_write_file = local.backend_map_config_userdata
    backend_map = join("", data.template_file.backends_map_config.*.rendered)
  }
}

data "template_file" "certificate_crt_content_indentation" {
  template = file("template/indentat_certificate_crt.tpl")

  vars = {
    certificate_crt_content = indent(6, file("template/certificate_crt.tpl"))
    #certificate_crt_content = join("", indent(6, data.template_file.certificate_crt_content.*.rendered))
  }
}

data "template_file" "private_key_content_indentation" {
  template = file("template/indentat_private_key.tpl")

  vars = {
    private_key_content = indent(6, file("template/private_key.tpl"))
    #private_key_content = join("", indent(6, data.template_file.private_key_content.*.rendered))
  }
}

data "template_file" "haproxy_crt" {
  template = file("template/haproxy_crt.tpl")
  vars = {
    haproxy_tls_write_file = local.haproxy_ssl_crt_config_userdata
    certificate_file_content = join("", data.template_file.certificate_crt_content_indentation.*.rendered)
    private_key_content = join("", data.template_file.private_key_content_indentation.*.rendered)
  }
}

data "template_file" "consul_client_config" {
  template = file("template/consul_client.hcl.tpl")
  vars = {
    remote_user = "centos"
  }
}

data "template_file" "consul_service_config" {
  template = file("template/consul.service.tpl")
  vars = {
    remote_user = "centos"
    remote_group = "centos"
  }
}

data "template_file" "resolved_conf_config" {
  template = file("template/resolved.conf.tpl")
}

data "template_file" "dnsmasq_consul_config" {
  template = file("template/dnsmasq-consul.tpl")
}

data "template_file" "cloud_config_all_write_files" {
  template = file("template/cloudconfig_write_files.tpl")
  vars = {
    cloud_config_write_files = local.cloud_config_write_files_pre
    cloud_config_haproxy_write_files_data = join("", tolist(data.template_file.haproxy_cfg_config_write_files.*.rendered))
    cloud_config_backends_map_write_files_data = join("", tolist(data.template_file.backends_map_config_write_files.*.rendered))
    cloud_config_consul_client_write_files_data = join("", tolist(data.template_file.consul_client_config.*.rendered))
    cloud_config_consul_service_write_files_data = join("", tolist(data.template_file.consul_service_config.*.rendered))
    cloud_config_resolved_conf_write_files_data = join("", tolist(data.template_file.resolved_conf_config.*.rendered))
    cloud_config_dnsmasq_consul_write_files_data = join("", tolist(data.template_file.dnsmasq_consul_config.*.rendered))
    cloud_config_haproxy_tls_write_files_data = join("", tolist(data.template_file.haproxy_crt.*.rendered))
  }
}

data "template_file" "consul_service_start" {
  template = file("template/haproxy_ip_associate_n_consul_start.tpl")
  
  vars = {
    haproxy_eip = data.aws_eip.haproxy.id
    remote_user = "centos"
    #run_instance_profile_id = aws_iam_instance_profile.haproxy_ec2.id
  }
} 

data "template_cloudinit_config" "haproxy_userdata" {
  gzip          = false
  base64_encode = false

  # haproxy configuration user_data file
  part {
    filename     = "cloud-config"
    content_type = "text/cloud-config"
    content      = join("", tolist(data.template_file.cloud_config_all_write_files.*.rendered))
  }
  # start consul service ; relocate haproxy eip 
  part {
    filename     = "runcmd.sh"
    content_type = "text/x-shellscript"
    content      = "${data.template_file.consul_service_start.rendered}" 
  }
}


data "template_file" "aws_auth_yaml_config" {
  template = file("template/aws-auth.yml.tpl")

  vars = {
    eks_worker_role_arn = var.eks_worker_role_arn
  }
}


data "template_file" "eks_readonly_role_yaml_config" {
  template = file("template/eks-readonly-role.yml.tpl")
}

data "template_file" "eks_readonly_role_binding_yaml_config" {
  template = file("template/eks-readonly-role-binding.yml.tpl")
}
