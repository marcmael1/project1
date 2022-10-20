variable "env_code" {
  type = string
}

variable "vpc_cidr" {}

variable "private_cidr" {}

variable "public_cidr" {}

variable "my_public_ip" {
  default = "96.241.18.31"
}
