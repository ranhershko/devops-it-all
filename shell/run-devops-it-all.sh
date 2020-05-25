#!/usr/bin/env bash

set -o pipefail

usage() {
    cat <<HELP
    Usage:
      # Without options:
      $(basename $0)
      # With options:
      $(basename $0) [ --github-sshkey-path | --github-user-email | --dockerhub-user | --dockerhub-pass | --ssl-privatekey-path | --ssl-crt-path | --dns-record | -h | --help ]
    Options:
      --github-sshkey-path      Github ssh privatekey file path.
      --github-user-email       Github user account email.
      --dockerhub-user          Dockerhub user account.
      --dockerhub-pass          Dockerhub user account password.
      --ssl-privatekey-path     Wilcard SSL private key file path.
      --ssl-crt-path            Wilcard SSL crt file path.
      --dns-record              DNS name for kubernetes wildcard DNS record pointing to AWS elastic IP named haproxy_scale_eip.
      -h, --help                Show usage.
    Example:
      $(basename $0) --github-sshkey-path ~/.ssh/id_rsa --github-user-email meongithub@gmail.com --dockerhub-user meondockerhub --dockerhub-pass meondockerhub-password --ssl-privatekey-path /tmp/ssl.key --ssl-crt-path /tmp/ssl.crt --dns-record running-on-kubernetes.com
HELP
    exit 1
}

# Handle opts
while [[ $# > 0 ]]
do
  key="$1"
  case ${key} in
      --github-sshkey-path) 
        github_sshkey="${2}"
        shift
      ;;
      --github-user-email)
        github_ssh_user_email="${2}"
        shift
      ;;
      --dockerhub-user)
        dockerhub_username="${2}"
        shift
      ;;
      --dockerhub-pass)
        dockerhub_password="${2}"
        shift
      ;;
      --ssl-privatekey-path)
        ssl_privatekey="${2}"
        shift
      ;;
      --ssl-crt-path) 
        ssl_crt="${2}"
        shift
      ;;
      --dns-record)
        dns_record="${2}"
        shift
      ;;
      -h|--help)
        usage
      ;;
      *)
        echo "Error: Unknown arg: [${key}]"
        usage
      ;;
  esac
  shift
done

echo "Start building 'devops-it-all' environment..."

login=false
while [ ${login} != "true" ]; do
  if [ -z "${github_sshkey}" ]; then
    read -p "Please enter your Github private key file path: " github_sshkey
  fi
  if [ -z "${github_ssh_user_email}" ]; then
    read -p "Please enter your Github user account email: " github_ssh_user_email
  fi

  ssh -i ${github_sshkey} -o StrictHostKeyChecking=no -T git@github.com  #>/dev/null 2>&1
  if [ $? -eq 1 ]; then
    login=true
  else
    echo "Incorrect Github authentication credentials, please enter again"
    github_ssh_user_email=""
    github_sshkey=""
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
  if [ -z "${dockerhub_username}" ]; then
    read -p "Please enter Dockerhub user: " dockerhub_username
  fi
  if [ -z "${dockerhub_password}" ]; then
    read -s -p "Please enter Dockerhub password: " dockerhub_password
  fi
  
  #echo ${dockerhub_password} |docker login --username ${dockerhub_username} --password ${dockerhub_password} -stdin | true
  docker login --username ${dockerhub_username} --password ${dockerhub_password} || true
  if [ ! $? ]; then
    echo "Incorrect Dockerhub authentication credentials, please enter again"
    dockerhub_username=""
    dockerhub_password=""
  else
    login=true
  fi
done

ssl_verify=false
while [ ${ssl_verify} != "true" ]; do
  if [ -z "${ssl_privatekey}" ]; then
    read -p "Please enter your SSL wildcard private key file path: " ssl_privatekey
  fi
  if [ -z "${ssl_crt}" ]; then
    read -p "Please enter your SSL wildcard crt file path: " ssl_crt
  fi

  privtekey_md5_hash=`openssl rsa -noout -modulus -in "${ssl_privatekey}"| openssl md5| sed 's/(stdin)=\ //g'`
  crt_md5_hash=`openssl x509 -noout -modulus -in "${ssl_crt}"| openssl md5| sed 's/(stdin)=\ //g'`
  if [ ${crt_md5_hash} != ${privtekey_md5_hash} ]; then
    echo "SSL crt and private key are mismatch"
    ssl_privatekey=""
    ssl_crt=""
  else
    ssl_verify=true
    cp "${ssl_privatekey}" ../terraform/aws/haproxy-autoscale/template/private_key.tpl
    cp "${ssl_crt}" ../terraform/aws/haproxy-autoscale/template/certificate_crt.tpl
  fi
done

ip_resolved=false
while [ ${ip_resolved} != "true" ]; do
  if [ -z "${dns_record}" ]; then
    read -p "Please enter kubernetes dns record name: " dns_record
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
   

ansible-playbook play-domainame-update.yml --tags prepare_management_server,first_time_run --extra-vars "domain_name=${dns_record}"
first_time_run=$(if [ $? -eq 0 ]; then echo "succeeded"; else echo "failed"; fi)
if [ ${first_time_run} == "succeeded" ]; then
  ansible-playbook play-build-devopsitall.yml --tags prepare_management_server,first_time_run
  first_time_run=$(if [ $? -eq 0 ]; then echo "succeeded"; else echo "failed"; fi)
    if [ ${first_time_run} == "succeeded" ]; then
      ansible-playbook play-build-devopsitall.yml --skip-tags prepare_management_server,first_time_run --extra-vars "local_user_home=${HOME} github_ssh_user_email=${github_ssh_user_email} github_sshkey=${github_sshkey} dockerhub_username=${dockerhub_username} dockerhub_password=${dockerhub_password} domain_name=${dns_record}"
    else
      echo "First time run failed - please fix and re-run"
      exit 400
    fi
else
  echo "First time run failed - please fix and re-run"
fi
