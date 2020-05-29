#!/usr/bin/env python

import boto3

delete='Delete AMI'
ec2 = boto3.client('ec2', region_name='us-east-1')
amis = ec2.describe_images(Owners=['self'], Filters=[{'Name':'tag:Name','Values':['devops-it-all-consulNhaproxy-AMI']}])

for ami in amis['Images']:
  print(f"ImageId: {ami['ImageId']}")
  print(f"CreationDate: {ami['CreationDate']}")
  #print(' '.join([ami['ImageId'], ami['CreationDate']]))
  print(f"Image tags: {ami['Tags']}")
  #print(ami['Tags'])
  reply = str(input(f'{delete} (y/n): ')).lower().strip()
  if reply[0] == 'y':
    print("deleting -> " + ami['ImageId'] + " - create_date = " + ami['CreationDate'])
    ec2.deregister_image(ImageId=ami['ImageId'])
