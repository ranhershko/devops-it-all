output "aws_vpc_id" {
  value = aws_vpc.kubernetes.id
}

output "aws_subnet_ids_private" {
  value = aws_subnet.kubernetes-private.*.id
}

output "aws_subnet_ids_public" {
  value = aws_subnet.kubernetes-public.*.id
}

output "aws_security_group" {
  value = aws_security_group.kubernetes.id
}

output "default_tags" {
  value = var.default_tags
}
