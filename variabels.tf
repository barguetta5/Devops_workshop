# variable "vpc_cider" {
#   type = string
#   description = "vpc_id"
#   default = "192.168.0.0/16"
# }
data "aws_vpc" "vpc_cidr" {
  cidr_block = "192.168.0.0/16"  # Replace with your VPC's CIDR block
}
data "aws_subnet" "private" {
  filter {
    name   = "cidrBlock"
    values = ["192.168.17.0/24"]  # Replace with your private subnet's CIDR block
  }
}

data "aws_subnet" "public" {
  filter {
    name   = "cidrBlock"
    values = ["192.168.16.0/24"]  # Replace with your public subnet's CIDR block
  }
}
# variable "subnet_private" {
#   type    = string
#   description = "list of all the subnets"
#   default = "192.168.17.0/24"
# }
# variable "subnet_public" {
#   type    = string
#   description = "list of all the subnets"
#   default = "192.168.16.0/24"
# }
# variable "subnet_private_id" {
#   type    = string
#   description = "list of all the subnets"
#   default = ""
# }
# variable "subnet_public_id" {
#   type    = string
#   description = "list of all the subnets"
#   default = ""
# }
# variable "vpc_cider" {
#   type = string
#   description = "vpc_id"
#   default = "192.123.11.0/16"
# }
# variable "subnet_private" {
#   type    = string
#   description = "list of all the subnets"
#   default = "192.111.10.0/24"
# }
# variable "subnet_public" {
#   type    = string
#   description = "list of all the subnets"
#   default = "192.111.12.0/24"