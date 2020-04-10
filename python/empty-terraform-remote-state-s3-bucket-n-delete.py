#!/usr/bin/env python

BUCKET = 'devopsitall-terraform-remote-state'

import boto3

s3 = boto3.resource('s3')
bucket = s3.Bucket(BUCKET)
bucket.object_versions.delete()

bucket.delete()
