variable "cidr_block" {
  default = "172.16.0.0/16"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "number_instaces" {
  type = number
  description = "Number of instaces"
}

variable "ssh_pubkey" {
  type = string
}

variable "subnet" {
  default = "172.16.0.0/24"
}
