data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20200907"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_region" "current" {}

resource "aws_key_pair" "deployer" {
  key_name   = "ec2-key"
  public_key = var.ssh_pubkey
}

resource "aws_instance" "web" {
  count                       = var.number_instaces
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.sg.id
  vpc_security_group_ids      = [aws_security_group.ssh.id, aws_security_group.intranet.id, aws_security_group.internet.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name

  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name = "k8s-${count.index == 0 ? "master" : "worker-${count.index}"}"
  }
}
