region                   = "us-east-1"
project_name             = "devops-it-all"
aws_vpc_cidr_block       = "10.10.0.0/16"
aws_public_subnets_cidr  = ["10.10.3.0/24", "10.10.4.0/24", "10.10.5.0/24"]
aws_private_subnets_cidr = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
worker_instance_type     = "a1.xlarge"
default_tags             = {
    Owner       = "Ran"
    Purpose     = "Learning"
    Project     = "devops-it-all"
    Created_by  = "Terraform-devops-it-all"
}

