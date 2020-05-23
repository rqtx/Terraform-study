# Network basics block
resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"

  tags = {
    Name = "ansible"
  }
}

resource "aws_subnet" "ansible" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet
  availability_zone = "${data.aws_region.current.name}a"

  tags = {
    Name = "ansible"
  }
}

# security group Block
resource "aws_security_group" "ansible" {
  name        = "Ansible_SG"
  description = "Allow Ansible traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "ansible"
  }
}

# security group rule ssh
resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ansible.id
}

resource "aws_security_group_rule" "ssh_egress" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ansible.id
}

# security group rule vpc
resource "aws_security_group_rule" "ansible_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.ansible.id
}

resource "aws_security_group_rule" "ansible_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ansible.id
}

# Allow internet-gateway traffic through subnet
# If we do not attach an route-table to subnets it will use the vpc subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ansible"
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "ansible-route-table"
  }
}

# Change main vpc route table to allow internet-gateway
resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.route-table.id
}

# Add a route table to subnet to not use vpc main route table and allow internet-gateway
#resource "aws_route_table_association" "subnet-association" {
#  subnet_id      = aws_subnet.ansible.id
#  route_table_id = aws_route_table.route-table.id
#}