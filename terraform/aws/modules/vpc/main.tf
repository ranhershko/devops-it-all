resource "aws_vpc" "kubernetes" {
  cidr_block = var.aws_vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.default_tags, map(
      "Name", "kubernetes-${var.project_name}-vpc"
    ))
}

resource "aws_eip" "kubernetes" {
  count = (length(var.aws_public_subnets_cidr) <= length(var.aws_avail_zones) ? length(var.aws_public_subnets_cidr) : length(var.aws_avail_zones))
  vpc   = true

  tags = merge(var.default_tags, map(
    "Name", "kubernetes-${var.project_name}-nat${count.index + 1}-eip"
  ))
}

resource "aws_internet_gateway" "kubernetes" {
  vpc_id = aws_vpc.kubernetes.id

  tags = merge(var.default_tags, map(
    "Name", "kubernetes-${var.project_name}-igw"
  ))
}

resource "aws_subnet" "kubernetes-public" {
  vpc_id            = aws_vpc.kubernetes.id
  count             = length(var.aws_public_subnets_cidr)
  availability_zone = element(var.aws_avail_zones, count.index)
  cidr_block        = element(var.aws_public_subnets_cidr, count.index)

  tags = merge(var.default_tags, map(
      "Name", "kubernetes-${var.project_name}-pub-sub${count.index + 1}-${element(var.aws_avail_zones, count.index)}"
    )
  )
}

resource "aws_nat_gateway" "kubernetes" {
  count         = length(aws_eip.kubernetes)
  allocation_id = element(aws_eip.kubernetes.*.id, count.index)
  subnet_id     = element(aws_subnet.kubernetes-public.*.id, count.index)

  tags = merge(var.default_tags, map(
    "Name", "kubernetes-${var.project_name}-natgw${count.index + 1}"
  ))
}

resource "aws_subnet" "kubernetes-private" {
  vpc_id            = aws_vpc.kubernetes.id
  count             = length(var.aws_private_subnets_cidr)
  availability_zone = element(var.aws_avail_zones, count.index)
  cidr_block        = element(var.aws_private_subnets_cidr, count.index)

  tags = merge(var.default_tags, map(
      "Name", "kubernetes-${var.project_name}-priv-sub${count.index + 1}-${element(var.aws_avail_zones, count.index)}"
    )
  )
}

resource "aws_route_table" "kubernetes-public" {
  vpc_id = aws_vpc.kubernetes.id
  route {
    cidr_block = var.internet_default_route_cidr
    gateway_id = aws_internet_gateway.kubernetes.id
  }

  tags = merge(var.default_tags, map(
      "Name", "kubernetes-${var.project_name}-public-rt"
    ))
}

resource "aws_route_table" "kubernetes-private" {
  count  = length(var.aws_public_subnets_cidr)
  vpc_id = aws_vpc.kubernetes.id
  route {
    cidr_block     = var.internet_default_route_cidr
    nat_gateway_id = element(aws_nat_gateway.kubernetes.*.id, count.index % length(aws_nat_gateway.kubernetes))
  }

  tags = merge(var.default_tags, map(
      "Name", "kubernetes-${var.project_name}-private-rt${count.index + 1}"
    ))
}

resource "aws_route_table_association" "kubernetes-public" {
  count          = length(aws_subnet.kubernetes-public)
  subnet_id      = element(aws_subnet.kubernetes-public.*.id, count.index)
  route_table_id = aws_route_table.kubernetes-public.id
}

resource "aws_route_table_association" "kubernetes-private" {
  count          = length(aws_subnet.kubernetes-private)
  subnet_id      = element(aws_subnet.kubernetes-private.*.id, count.index)
  route_table_id = element(aws_route_table.kubernetes-private.*.id, count.index % length(aws_nat_gateway.kubernetes))
}

resource "aws_security_group" "kubernetes_worker" {
  name   = "kubernetes-${var.project_name}-worker-sg"
  vpc_id = aws_vpc.kubernetes.id

  tags = merge(var.default_tags, { 
      "Name" = "kubernetes-${var.project_name}-workers-sg"#,
      #"kubernetes.io/cluster/kubernetes-${var.project_name}" = "owned"
      }
    )
}

resource "aws_security_group_rule" "allow-https-ingress-from-github-webhook" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.github_webhook_ips
  security_group_id = aws_security_group.kubernetes_worker.id
}

resource "aws_security_group_rule" "allow-worker-ingress-using-nat-ips" {
  count             = length(aws_eip.kubernetes)
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["${element(aws_eip.kubernetes.*.public_ip, count.index)}/32"]
  security_group_id = aws_security_group.kubernetes_worker.id
}

resource "aws_security_group_rule" "allow-all-ingress-inside-vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  #cidr_blocks      = [var.aws_vpc_cidr_block]
  self              = true
  security_group_id = aws_security_group.kubernetes_worker.id
}

resource "aws_security_group_rule" "allow-eks-control-ingress-app-worker" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.kubernetes_worker.id
  source_security_group_id = aws_security_group.kubernetes_eks_control.id
}

resource "aws_security_group_rule" "allow-eks-control-ingress-https-worker" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.kubernetes_worker.id
  #cidr_blocks              = aws_eip.kubernetes.*.public_ip
  source_security_group_id = aws_security_group.kubernetes_eks_control.id
}

resource "aws_security_group_rule" "allow-worker-all-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = [var.internet_default_route_cidr]
  security_group_id = aws_security_group.kubernetes_worker.id
}

resource "aws_security_group_rule" "allow-management-connections" {
  type              = "ingress"
  from_port         = 0
  #from_port         = var.ssh_port
  #to_port           = var.ssh_port
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = aws_security_group.kubernetes_worker.id
}

resource "aws_security_group" "kubernetes_eks_control" {
  name   = "kubernetes-${var.project_name}-eks-control-sg"
  vpc_id = aws_vpc.kubernetes.id

  tags = merge(var.default_tags, {
      "Name" = "kubernetes-${var.project_name}-control-sg"#,
      #"kubernetes.io/cluster/kubernetes-${var.project_name}" = "owned"
      }
  )
}

resource "aws_security_group_rule" "allow-eks-ingress-https-from-vpc" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.kubernetes_eks_control.id
  source_security_group_id = aws_security_group.kubernetes_worker.id
}

resource "aws_security_group_rule" "allow-eks-ingress-https-from-manage-ip" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.kubernetes_eks_control.id
  cidr_blocks              = ["${chomp(data.http.myip.body)}/32"]
}

#resource "aws_security_group_rule" "allow-eks-control-all-egress-2-worker" {
  #type                     = "egress"
  #from_port                = 1025
  #to_port                  = 65535
  #protocol                 = "tcp"
  #security_group_id        = aws_security_group.kubernetes_eks_control.id
  #source_security_group_id = aws_security_group.kubernetes_worker.id
#}

resource "aws_security_group_rule" "allow-eks-control-all-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = [var.internet_default_route_cidr]
  security_group_id = aws_security_group.kubernetes_eks_control.id
}
