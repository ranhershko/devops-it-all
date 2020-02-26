#resource "aws_eip" "haproxy" {
  #vpc = true
#
  #tags = {
    #Name = "haproxy_devopsitall_eip"
  #}
#}

resource "aws_launch_configuration" "haproxy" {
  name_prefix                 = "haproxy_launch_configuration_devopsitall-"
  image_id                    = data.aws_ami.devops-it-all-consulNhaproxy-AMI.id
  instance_type               = var.haproxy_instance_type
  key_name                    = "devopsitall"
  security_groups             = [data.terraform_remote_state.vpc-n-eks.outputs.aws_worker_security_group]
  #associate_public_ip_address = true

  user_data_base64            = data.template_cloudinit_config.haproxy_userdata.renered
  ##cloud-config
  #runcmd:
    #- aws ec2 associate-address --instance-id $(curl http://169.254.169.254/latest/meta-data/instance-id) --allocation-id ${data.aws_eip.haproxy.id} --allow-reassociation
  #EOF
}

resource "aws_autoscaling_group" "haproxy" {
  name                  = "haproxy_autoscaling_devopsitall"
  launch_configuration  = aws_launch_configuration.haproxy.name
  vpc_zone_identifier   = data.terraform_remote_state.vpc-n-eks.outputs.aws_subnet_ids_public
  min_size              = var.haproxy_scale_size
  max_size              = var.haproxy_scale_size
  desired_capacity      = var.haproxy_scale_size
  health_check_type     = "EC2"
  force_delete          = true
  
  tag { 
    key                 = "Name"
    value               = "haproxy_devopsitall_autoscaling" 
    propagate_at_launch = true
  }
}
