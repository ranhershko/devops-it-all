# devops-it-all
   
   ## As it say - try to devops it all:
   ##### Build AWS vpc, eks
   ##### Manage Hashicorp consul, vault 
   ##### Run Jenkins apps pipelines
        WORK IN PROGRESS...
   <img src="images/env-status.png" width="1200" >
   
   ## Prerequisite:
   ###### 1) Create an AWS Elastic IP nameed: haproxy_scale_eip
   ###### 2) Create a Dns wildcard record for that Elastic IP
   ###### 3) Create SSL wildcard certificate for this Dns wildcard record
   ###### 4) Github user email and ssh private key that used by that account
   ###### 4) Dockerhub account user and password 


   ## Running steps:
   ###### 1) git clone devops-it-all repo
   ###### 2) cd devops-it-all/ansible
   ###### 3) Running the environment build: 
   ######## a) Automatic: ../shell/run-devops-it-all.sh "Github ssh private key path" "Github account email" "Dockerhub user" "Dockerhub password"
   ######## b) Manually: ../shell/run-devops-it-all.sh => answer the github dockerhub login information
        
   ## When done:
   ###### 1) cd devops-it-all/terraform/aws/haproxy-autoscale/
   ###### 2) terraform destroy --auto-approve
   ###### 3) cd ~/devops-it-all/terraform/aws/haproxy-autoscale/remote_state/
   ###### 4) terraform destroy --auto-approve
   ###### 5) cd ~/devops-it-all/terraform/aws/vpc-n-eks-devops-it-all/
   ###### 6) terraform destroy --auto-approve
   ###### 7) AWS web console => Amazon S3 => devopsitall-terraform-remote-state => Change Version from Hide to Show and delete all files
   ###### 8) cd ~/devops-it-all/terraform/aws/vpc-n-eks-devops-it-all/remote_state/
   ###### 9) terraform destroy --auto-approve
   ###### 10) There maybe be a volumes in the ec2 blade that need to delete manually
