module "vpc" {
  source             = "../modules/vpc"
  aws_avail_zones = data.aws_availability_zones.available.names
  aws_private_subnets_cidr = var.aws_private_subnets_cidr
  aws_public_subnets_cidr = var.aws_public_subnets_cidr
  aws_vpc_cidr_block = var.aws_vpc_cidr_block
  default_tags = merge(var.default_tags, map("kubernetes.io/cluster/${var.project_name}", "shared"))
  project_name = var.project_name
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  cluster_name                    = "kubernetes-${var.project_name}"
  subnets                         = module.vpc.aws_subnet_ids_private
  tags                            = var.default_tags
  vpc_id                          = module.vpc.aws_vpc_id
  cluster_endpoint_private_access = true
  worker_groups                   = [
    {
      name                          = "eks-worker-group"
      instance_type                 = var.worker_instance_type
      asg_desired_capacity          = 3
      asg_min_size                  = 3
      worker_security_group_id      = module.vpc.aws_worker_security_group
      cluster_security_group_id     = module.vpc.aws_eks_control_security_group
      manage_cluster_iam_resources  = false
      cluster_iam_role_name         = aws_iam_role.kubernetes-eks-admin.name
      workers_role_name             = aws_iam_role.kubernetes-eks-worker.name
      worker_iam_role_name          = aws_iam_role.kubernetes-eks-worker.name
      write_kubeconfig              = true
      kubeconfig_filename           = "config"
      key_name                      = replace(var.project_name, "-", "")
    }
  ]
}

resource "tls_private_key" "kubernetes" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "kubernetes" {
  key_name   = replace(var.project_name, "-", "")
  public_key = tls_private_key.kubernetes.public_key_openssh
}

resource "local_file" "kubernetes" {
  sensitive_content = tls_private_key.kubernetes.private_key_pem
  filename          = "${aws_key_pair.kubernetes.key_name}.pem"
  file_permission   = "0600"
}

resource "local_file" "kubernetes_pub_key" {
  sensitive_content = tls_private_key.kubernetes.public_key_openssh
  filename          = "${aws_key_pair.kubernetes.key_name}.pem.pub"
  file_permission   = "0600"
}
