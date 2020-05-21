#!/bin/bash

usage="$(basename "$0") [-h] "Github ssh private key path" "Github account email" "Dockerhub user" "Dockerhub password" "SSL wildcard private key path" "SSL wildcard crt path" "Haproxy DNS wildcard"

variables_recived=false
if [[ (-f "$1") && (! -z "$2") && (! -z "$3") && (! -z "$4") && (-f "$5") && (-f "$6") && (! -z "$7") ]]; then
  github_sshkey="$1"
  github_ssh_user_email="$2"
  dockerhub_username="$3"
  dockerhub_password="$4" 
  ssl_privatekey="$5"
  ssl_crt="$6"
  dns_record="$7"
  variables_recived=true
fi

case $1 in 
 -h) echo $usage 
     exit 0
     ;;
  *) echo "Start building 'devops-it-all' environment..."
     if [[ (${variables_recived} != "true") ]]; then
       echo "This configuration need the next inputs"
       echo "1) Github ssh private key(Full path)"
       echo "2) Github ssh user account email"
       echo "3) Dockerhub user and password"
       echo "4) SSL wildcard certificate and privatekey paths"
       echo "5) Haproxy DNS wildcard record pointing to AWS Elastic IP name 'haproxy_scale_eip'"
     fi
     ;;

if [[ (-f "$1") && (! -z "$2") && (! -z "$3") && (! -z "$4") && (-f "$5") && (-f "$6") && (! -z "$7") ]]; then
  variables_recived=true
else
  variables_recived=false
fi

login=false
while [ ${login} != "true" ]; do
  if [[ (${variables_recived} != "true") ]]; then
    read -p "Please enter your Github user account email: " github_ssh_user_email
    read -p "Please enter your Github private key file path: " github_sshkey
  fi
  ssh -i ${github_sshkey} -o StrictHostKeyChecking=no -T git@github.com  #>/dev/null 2>&1
  if [ $? -eq 1 ]; then
    login=true
  else
    echo "Wrong input, please enter again"
    variables_recived=false
  fi
done
  
# Install docker package
#if [! [ $(which docker)  && [ $(docker --version) ]]; then
docker --version >/dev/null 2>&1
if [ ! $? ]; then
  sudo yum update -y
  
  if [ ! -f /etc/yum.repos.d/docker-ce.repo ]; then
    sudo tee /etc/yum.repos.d/docker-ce.repo <<-'EOF'
    [docker-ce-stable]
    name=Docker CE Stable - $basearch
    baseurl='https://download.docker.com/linux/centos/7/$basearch/stable'
    enabled=1
    gpgcheck=1
    gpgkey=https://download.docker.com/linux/centos/gpg
EOF
  fi
  
  sudo yum install docker-ce docker-ce-cli -y
  sudo usermod -aG docker ${USER}

  sudo systemctl enable docker
  sudo systemctl start docker
fi

login=false
while [ ${login} != "true" ]; do
  if [[ (${variables_recived} != "true") ]]; then
    read -s -p "Please enter Dockerhub password: " dockerhub_password
    read -p "Please enter Dockerhub user: " dockerhub_username
  fi
  
  #echo ${dockerhub_password} |docker login --username ${dockerhub_username} --password ${dockerhub_password} -stdin | true
  docker login --username ${dockerhub_username} --password ${dockerhub_password} || true
  if [ ! $? ]; then
    echo "The Dockerhub user or password are incorrect, try again"
    variables_recived=false
  else
    login=true
  fi
done

ssl_verify=false
while [ ${ssl_verify} != "true" ]; do
  if [[ (${variables_recived} != "true") ]]; then
    read -p "Please enter your SSL wildcard private key file path: " ssl_privatekey
    read -p "Please enter your SSL wildcard crt file path: " ssl_crt
  fi

  privtekey_md5_hash=`openssl rsa -noout -modulus -in "${ssl_privatekey}"| openssl md5| sed 's/(stdin)=\ //g'`
  crt_md5_hash=`openssl x509 -noout -modulus -in "${ssl_crt}"| openssl md5| sed 's/(stdin)=\ //g'`
  if [ ${crt_md5_hash} != ${privtekey_md5_hash} ]; then
    echo "SSL crt and private key are mismatch"
    variables_recived=false
  else
    ssl_verify=true
    cp "${ssl_privatekey}" ../terraform/aws/haproxy-autoscale/template/private_key.tpl
    cp "${ssl_crt}" ../terraform/aws/haproxy-autoscale/template/certificate_crt.tpl
  fi
done

ip_resolved=false
while [ ${ip_resolved} != "true" ]; do
  if [[ (${variables_recived} != "true") ]]; then
    read -p "Please enter haproxy dns record" dns_record
  fi

  resolved_ip=`nslookup *.${dns_record}|sed -n '/'${dns_record}'/{n;p}'|awk '{print $2}'`
  elastic_ip=`aws ec2 describe-addresses --filters "Name=tag-value,Values=haproxy_scale_eip" --query 'Addresses[].PublicIp'|sed -n '/\".*\"/{p}'`
  if [ $elastic_ip != \"$resolved_ip\" ] ; then 
    echo "The domain ${dns_record} doesn\'t resolve to aws elastic ip name 'haproxy_scale_eip'. Fix and try again"
    exit 400
  else
    ip_resolved=true
  fi
done
   
ansible-playbook play-helm-test.yml --tags prepare_management_server,first_time_run
ansible-playbook play-helm-test.yml --skip-tags prepare_management_server,first_time_run --extra-vars "local_user_home=${HOME} github_ssh_user_email=${github_ssh_user_email} github_sshkey=${github_sshkey} dockerhub_username=${dockerhub_username} dockerhub_password=${dockerhub_password}"

# Install VPC, EKS and all management helm charts
#prepare_status=$(ansible-playbook play-helm-test.yml --tags prepare_management_server,first_time_run|tail -1|awk '{print $6}')
#if [ "${prepare_status}" == 'failed=0' ]; then
#fi
#ansible-playbook play-eks-cosnul-n-vault.yml --tags prepare_management_server,first_time_run
#ansible-playbook play-eks-cosnul-n-vault.yml --skip-tags prepare_management_server,first_time_run --extra-vars "local_user_home=${HOME} github_ssh_user_email=${github_ssh_user_email} github_sshkey=${github_sshkey} dockerhub_username=${dockerhub_username} dockerhub_password=${dockerhub_password}" -vvvv

