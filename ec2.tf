data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["IaaSWeek-${var.hash_commit}"]
  }

  owners = ["777015859311"] # Gomex ID, não mude sem mudar o filtro
}

data "aws_region" "current" {}

resource "aws_key_pair" "deployer" {
  key_name   = "ec2-key"
  public_key = var.ssh_pubkey
}

resource "aws_instance" "web" {
  count                       = var.number_instaces
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.ansible.id
  vpc_security_group_ids      = [aws_security_group.ansible.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name

  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name = "ansible-${count.index}"
  }
}
