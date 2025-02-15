variable "iam_number" {
  type = string
  description = "iam_numebr"
}
variable "vpc_id" {
  type = string
  description = "vpc_id"
}
variable "subnet_ids" {
  type    = list(string)
  description = "list of all the subnets"
}

