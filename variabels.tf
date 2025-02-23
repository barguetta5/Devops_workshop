data "aws_vpc" "vpc_cidr" {
  cidr_block = "192.168.0.0/16"  
}
data "aws_subnet" "private" {
  filter {
    name   = "cidrBlock"
    values = ["192.168.17.0/24"]
  }
}

data "aws_subnet" "public" {
  filter {
    name   = "cidrBlock"
    values = ["192.168.16.0/24"]
  }
}
