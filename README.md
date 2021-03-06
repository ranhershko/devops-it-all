# devops-it-all
   
   ### As it says - try to devops it all:
   ##### Create automation environment using shell. python, ansible, terraform, helm, packer
   ##### Build on Amazon AWS VPC, EKS..
   ##### Build and run Jenkins devops-it-all apps common automation pipeline 
   ######      using https://github.com/ranhershko/devops-it-all-jenkinsfile repo
   ##### Using Hashicorp consul service discovery and vault manage secrets..
   ##### Build ELK stack for managing logs
   ##### Build Prometheus monitoring system and Grafana for querying and visualize metrics
        WORK IN PROGRESS...
   <img src="images/env-status.png" width="1200" >
   
   ### Prerequisite:
   ##### 1) Create an AWS Elastic IP named: haproxy_scale_eip
   ##### 2) Create a DNS wildcard record for this Elastic IP
   ##### 3) Create SSL wildcard certificate for this Dns wildcard record
   ##### 4) Github user email and ssh private key that is used by this account
   ##### 5) Dockerhub account user and password 


   ### Running steps:
   #### 1) git clone devops-it-all repo
   #### 2) cd devops-it-all/ansible
   #### 3) Environment build: 
   #### Automatically: 
   ##### run-devops-it-all.sh [ --github-sshkey-path | --github-user-email | --dockerhub-user | --dockerhub-pass | --ssl-privatekey-path | --ssl-crt-path | --dns-record | -h | --help ]
   #### example: 
   ##### ../shell/run-devops-it-all.sh --github-sshkey-path ~/.ssh/id_rsa --github-user-email meongithub@gmail.com --dockerhub-user meondockerhub --dockerhub-pass meondockerhub-password --ssl-privatekey-path /tmp/ssl.key --ssl-crt-path /tmp/ssl.crt --dns-record running-on-kubernetes.com
   #### Manually: (answer github & dockerhub login information, wildcard SSL private key and crt files path, DNS name for kubernetes wildcard DNS pointing to AWS elastic IP named haproxy_scale_eip
   ##### ../shell/run-devops-it-all.sh
        
   #### Management apps UI & endpoints (Limited access only to management server)
   ###### https://prometheus."Domain Name"
   ###### https://grafana."Domain Name"
   ##### Grafana admin password:
   ###### printf $(kubectl get secret --namespace management grafana-devopsitall -o jsonpath="{.data.admin-password}") | base64 --decode ; echo
   ###### https://elasticsearch."Domain Name"
   ###### https://kibana."Domain Name"
   ###### https://jenkins."Domain Name"
   ##### Jenkins admin password: 
   ###### printf $(kubectl get secret --namespace management jenkins-devopsitall -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
   ###### https://consul."Domain Name"
   ###### https://vault."Domain Name"

   ### When done: (destroy)
   ##### 1) cd devops-it-all
   ##### 2) ./shell/destroy_environment.sh
