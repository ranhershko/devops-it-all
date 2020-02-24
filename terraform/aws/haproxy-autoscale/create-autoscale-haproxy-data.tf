data "terraform_remote_state" "vpc-n-eks" {
  backend = "s3"
  config = {
    bucket = "devopsitall-terrform-remote-state"
    key    = "vpc-n-eks-terrform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "devops-it-all-consulNhaproxy-AMI"
  most_recent = true
  owners      = ["self"]
  most_recent = true

  filter {
    name   = "tag:Name"
    values = ["devops-it-all-consulNhaproxy-AMI*"]
  }
}

data "aws_eip" "haproxy" {
  tags = {
    Name = "haproxy_scale_eip"
  }
}
