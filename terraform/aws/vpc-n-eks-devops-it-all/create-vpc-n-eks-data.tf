data "aws_eks_cluster" "cluster" {
  name  = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_availability_zones" "available" {}

data "http" "myip" {
  url = "https://api.ipify.org/"
}
