# devops-it-all
   
   ## As it say - try to devops it all:
   ##### Build AWS vpc, eks
   ##### Manage Hashicorp consul, vault 
   ##### Run Jenkins apps pipelines
        WORK IN PROGRESS...
   <img src="images/env-status.png" width="1200" >
   
   ## Prerequisite:
   ###### 1) AWS Elastic IP nameed: haproxy_scale_eip
   ###### 2) Dns wildcard record for the Elastic IP
   ###### 3) SSL wildcard certificate for this Dns wildcard record

   ## Running steps:
   ###### 1) git clone devops-it-all repo
   ###### 2) cd devops-it-all/ansible
   ###### 3) ansible-playbook play-devops-it-all.yml --tags prepare_management_server,first_time_run 
   ###### 4) ansible-playbook play-devops-it-all.yml --skip-tags prepare_management_server,first_time_run

   ## When done:
   ###### 1) cd devops-it-all/terraform/aws/haproxy-autoscale/
   ###### 2) terraform destroy --auto-approve
   ###### 3) cd ~/devops-it-all/terraform/aws/haproxy-autoscale/remote_state/
   ###### 4) terraform destroy --auto-approve
   ###### 5) cd ~/devops-it-all/terraform/aws/vpc-n-eks-devops-it-all/
   ###### 6) terraform destroy --auto-approve
   ###### 7) AWS web console = > Amazon S3 => devopsitall-terraform-remote-state => Change Version from Hide to Show and delete all files
   ###### 8) cd ~/devops-it-all/terraform/aws/vpc-n-eks-devops-it-all/remote_state/
   ###### 9) terraform destroy --auto-approve
