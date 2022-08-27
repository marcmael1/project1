variable "env_code" {
  type = string
}

variable "vpc_cidr" {}

variable "private_cidr" {}

variable "public_cidr" {}

variable "instance_type" {
  default = "t2.micro"
}
