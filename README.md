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
   ###### git clone devops-it-all repo
   ###### cd devops-it-all/ansible
   ###### ansible-playbook play-devops-it-all.yml --tags prepare_management_server,first_time_run 
   ###### ansible-playbook play-devops-it-all.yml --skip-tags prepare_management_server,first_time_run
