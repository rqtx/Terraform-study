variable "cidr_block" {
  default = "172.16.0.0/16"
}

variable "subnet" {
  default = "172.16.0.0/24"
}

variable "number_instaces" {
  type = number
  description = "Number of instaces"
}

variable "ssh_pubkey" {
  type = string
}

variable "hash_commit" {
  default = "806d52dafe9b7fddbc4f0d2d41086ed3cfa02a44"
}
