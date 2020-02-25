locals {
  userdata = <<-USERDATA
    #!/bin/bash
    cat <<"__EOF__" > /etc/haproxy/haproxy.cfg
    file("../../../ansible/roles/haproxy-lb/files/haproxy.cfg")
    #cloud-config
    runcmd:
      - aws ec2 associate-address --instance-id $(curl http://169.254.169.254/latest/meta-data/instance-id) --allocation-id ${data.aws_eip.haproxy.id} --allow-reassociation
  USERDATA
}
