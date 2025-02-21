variable "vpc_cider" {
  type = string
  description = "vpc_id"
  default = "192.168.0.0/16"
}
variable "subnet_private" {
  type    = string
  description = "list of all the subnets"
  default = "192.168.17.0/24"
}
variable "subnet_public" {
  type    = string
  description = "list of all the subnets"
  default = "192.168.16.0/24"
}
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
