variable "region" {
  default = "us-west-1"
}

variable "remote_state_bucket" {}
variable "remote_state_key" {}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR Block"
}

variable "private_subnet_1_cidr" {}
variable "public_subnet_1_cidr" {}