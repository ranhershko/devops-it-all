#!/bin/bash
set -ex 

mkdir /home/${ remote_user }/consul-client-data || true
chown -R ${ remote_user }:${ remote_user } /home/${ remote_user }/consul-client-data
chmod -R 700 /home/${ remote_user }/consul-client-data

export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)

ln -s /usr/local/bin/aws /usr/bin/aws || true
aws ec2 wait instance-running --instance-ids $(curl http://169.254.169.254/latest/meta-data/instance-id)
aws ec2 associate-address --instance-id $(curl http://169.254.169.254/latest/meta-data/instance-id) --allocation-id ${haproxy_eip} --allow-reassociation
runuser -l  ${ remote_user } -c "aws eks update-kubeconfig --name kubernetes-devops-it-all --region $(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)"

systemctl daemon-reload
systemctl enable dnsmasq
systemctl restart dnsmasq
systemctl enable consul
systemctl restart consul
systemctl restart haproxy
systemctl restart systemd-resolved.service
