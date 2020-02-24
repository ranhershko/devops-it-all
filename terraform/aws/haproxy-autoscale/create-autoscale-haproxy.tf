#resource "aws_eip" "haproxy" {
  #vpc = true
#
  #tags = {
    #Name = "haproxy_devopsitall_eip"
  #}
#}

resource "aws_launch_configuration" "haproxy" {
  name_prfix                  = "haproxy_devopsitall_launch_configuration-"
  image_id                    = data.aws_ami.devops-it-all-consulNhaproxy-AMI.id
  instance_type               = var.instance_type
  key_name                    = "devopsitall"
  security_groups             = [data.terraform_remote_state.vpc.aws_worker_security_group]
  associate_public_ip_address = true

  user_data = <<EOF
  #cloud-config
  runcmd:
    - aws ec2 associate-address --instance-id $(curl http://169.254.169.254/latest/meta-data/instance-id) --allocation-id ${data.aws_eip.haproxy.id} --allow-reassociation
  EOF
}

resource "aws_autoscaling_group" "haproxy" {
  name                  = "haproxy_devopsitall_autoscaling"
  launch_configuration  = aws_launch_configuration.haproxy.name
  vpc_zone_identifier   = data.terraform_remote_state.vpc.aws_subnet_ids_public
  min_size              = var.haproxy_scale_size
  max_size              = var.haproxy_scale_size
  desired_capacity      = var.haproxy_scale_size
  health_check_type     = "EC2"
  force_delete_true     = true
  
  tag { 
    key                 = "Name"
    value               = "haproxy_devopsitall_autoscaling" 
    propagate_at_launch = true
  }
}
