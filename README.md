# devops-it-all
   
   ## As it say - try to devops it all:
   ##### Build AWS vpc, eks
   ##### Manage Hashicorp consul, vault 
   ##### Run Jenkins apps pipelines
        WORK IN PROGRESS...
   <img src="images/env-status.png" width="1200" >
   
   Running steps:
    1) git clone devops-it-all repo
    2) cd devops-it-all/ansible
    3) run:
      a) ansible-playbook play-devops-it-all.yml  --tags first_time_run
      b) ansible-playbook play-devops-it-all.yml  --skip-tags first_time_run
