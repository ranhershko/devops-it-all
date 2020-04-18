output "aws_vpc_id" {
  value = aws_vpc.kubernetes.id
}

output "aws_subnet_ids_private" {
  value = aws_subnet.kubernetes-private.*.id
}

output "aws_subnet_ids_public" {
  value = aws_subnet.kubernetes-public.*.id
}

output "aws_worker_security_group" {
  value = aws_security_group.kubernetes_worker.id
}

output "aws_eks_control_security_group" {
  value = aws_security_group.kubernetes_eks_control.id
}

output "aws_vpc_nat_public_ips" {
  value = aws_eip.kubernetes.*.public_ip
}

output "default_tags" {
  value = var.default_tags
}
