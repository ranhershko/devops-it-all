#!/bin/bash -xv
cd terraform/aws/haproxy-autoscale/
terraform destroy --auto-approve
cd remote_state/
terraform destroy --auto-approve
cd ../../helm
for helm_dir in `ls -la|grep ^d|tail -9|awk '{print $9}'` ; do cd $helm_dir; terraform destroy --auto-approve; cd remote_state ; terraform destroy --auto-approve; cd ../..; done
cd ../vpc-n-eks-devops-it-all
terraform destroy --auto-approve
for leftover_resources in `ls ../../../python/delete_env/` ; do python3 ../../../python/delete_env/${leftover_resources} ; done
cd remote_state/
terraform destroy --auto-approve
if [ -f ~/.kube/config ] ; then rm ~/.kube/config ; fi
