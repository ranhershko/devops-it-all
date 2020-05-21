#!/usr/bin/env python

import boto3
ec2 = boto3.resource('ec2',region_name='us-east-1')
for vol in ec2.volumes.all():
  if vol.state=='available':
    need_2_delete = False
    current_vol_name = ""
    for tag in vol.tags:
      if tag['Key'] == "Name":
        current_vol_name = tag['Value']
      if tag['Key'] == "kubernetes.io/cluster/kubernetes-devops-it-all":
        need_2_delete = True
    if need_2_delete:
      print(f"Deleting {current_vol_name} volume")
      #current_vol=ec2.Volume(vol.id)
      ec2.Volume(vol.id).delete()
      need_2_delete = False
      current_vol_name = ""
      
