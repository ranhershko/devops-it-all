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

data "template_file" "haproxy_cfg" {
  template = file("../../../ansible/roles/haproxy-lb/files/haproxy.cfg")
}

data "template_file" "backends_map" {
  template = file("../../../ansible/roles/haproxy-lb/files/backends.map")
}

data "template_file" "consul_service" {
  template = file("../../../ansible/roles/haproxy-lb/files/consul.service")
}

data "template_cloudinit_config" "haproxy_userdata" {
  gzip          = true
  base64_encode = true

  # get haproxy configuration user_data file
  part {
    filename     = "haproxy.cfg"
    content_type = "text/part-handler"
    content      = "${data.template_file.haproxy_cfg.rendered}"
  }

  # get haproxy backends map configuration user_data file
  part {
    filename     = "backends.map"
    content_type = "text/part-handler"
    content      = "${data.template_file.backends_map.rendered}"
  }
  # get haproxy consul service configuration user_data file
  part {
    filename     = "consul.service"
    content_type = "text/part-handler"
    content      = "${data.template_file.consul_service.rendered}"
  } 
}

locals {
  userdata = <<-COMMON_USERDATA
    systemctl daemon-reload
    systemctl enable consul
    systemctl start consul
    aws ec2 associate-address --instance-id $(curl http://169.254.169.254/latest/meta-data/instance-id) --allocation-id ${data.aws_eip.haproxy.id} --allow-reassociation
  COMMON_USERDATA
}
