#!/bin/bash

echo "Start building 'devops-it-all' environment..."
echo "This configuration need the next inputs"
echo "Github ssh private key(Full path)"
echo "Github ssh user account email"
echo "Dockerhub user and password"

login=false

count=0
while [ ${login} != "true" ]; do
  if [[ ( -f "$1") && (count -eq 0) ]]; then
    github_sshkey="$1"
    if [ ! -z "$2" ]; then
      github_ssh_user_email="$2"
    else
      read -p "Please enter your Github user account email: " github_ssh_user_email
    fi
    count=$(expr $count + 1)  
  else
    read -p "Please enter your Github private key: " github_sshkey
  fi
  ssh -i ${github_sshkey} -o StrictHostKeyChecking=no -T git@github.com  #>/dev/null 2>&1
  if [ $? -eq 1 ]; then
    login=true
  else
    echo "Wrong input, please enter again"
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

count=0
while [ ${login} != "true" ]; do
  if [[ (! -z "$3") && (count -eq 0) ]]; then
    dockerhub_username="$3"
    if [ ! -z "$4" ]; then
      dockerhub_password="$4"
    else
     reed -s -p "Please enter Dockerhub password: " dockerhub_password
    fi
    count=$(expr $count + 1)
  else
    read -p "Please enter Dockerhub user: " dockerhub_username
  fi
  
  #echo ${dockerhub_password} |docker login --username ${dockerhub_username} --password ${dockerhub_password} -stdin | true
  docker login --username ${dockerhub_username} --password ${dockerhub_password} || true
  if [ ! $? ]; then
    echo "The Dockerhub user or password are incorrect, try again"
  else
    login=true
  fi
done

# Install VPC, EKS, consul cluster and vault cluster
#ansible-playbook play-eks-cosnul-n-vault.yml --tags prepare_management_server,first_time_run
ansible-playbook play-eks-cosnul-n-vault.yml --skip-tags prepare_management_server,first_time_run --extra-vars "local_user_home=${HOME} github_ssh_user_email=${github_ssh_user_email} github_sshkey=${github_sshkey} dockerhub_username=${dockerhub_username} dockerhub_password=${dockerhub_password}" -vvvv

