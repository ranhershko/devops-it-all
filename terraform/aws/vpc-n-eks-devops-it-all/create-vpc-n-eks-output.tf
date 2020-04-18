output "aws_worker_security_group" {
  value = module.vpc.aws_worker_security_group
}

output "aws_eks_control_security_group" {
  value = module.vpc.aws_eks_control_security_group
}

output "aws_subnet_ids_public" {
  value = module.vpc.aws_subnet_ids_public
}

output "aws_vpc_nat_public_ips" {
  value = module.vpc.aws_vpc_nat_public_ips
}
