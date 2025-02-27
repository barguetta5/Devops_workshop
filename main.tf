terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region  = "eu-west-1"
  profile = "default"
}
# The name of the bucket in s3
data "aws_s3_bucket" "bucket" {
  bucket = "barg-bucket2"  
}
# The path of the faile i will put int s3(the state file)
# resource "aws_s3_object" "object" {
#   bucket = data.aws_s3_bucket.bucket.bucket  
#   key    = "terraform.tfstate"
#   source = "/Users/devops-workshop-barg/wixproj/Devops_workshop/terraform.tfstate"
#   etag   = filemd5("/Users/devops-workshop-barg/wixproj/Devops_workshop/terraform.tfstate")
# }

# resource "aws_subnet" "private_subnet" {
#   vpc_id      = data.aws_vpc.vpc_cidr.id
#   cidr_block  = data.aws_subnet.private.cidr_block
#   availability_zone = "eu-west-1a"

#   tags = {
#     Name = "barg-privat"
#   }
# }
# resource "aws_subnet" "public_subnet" {
#   vpc_id      = data.aws_vpc.vpc_cidr.id
#   cidr_block  = data.aws_subnet.public.cidr_block
#   availability_zone = "eu-west-1b"

#   tags = {
#     Name = "barg-public"
#   }
# }

# resource "aws_internet_gateway" "devops-workshop-igw" {
#   vpc_id      = data.aws_vpc.vpc_cidr.id
# }
# resource "aws_route_table" "BarGu_RT"{
#   vpc_id      = data.aws_vpc.vpc_cidr.id
#   route{
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.devops-workshop-igw.id
#   }

# }

# resource "aws_route_table_association" "barG-publicRTassociation" {
#   subnet_id      = aws_subnet.public_subnet.id
#   route_table_id = aws_route_table.BarGu_RT.id

# }

# Creating the eks module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0"

  cluster_name    = "barg-cluster"
  cluster_version = "1.29"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  # EKS Addons I dont know yet what it is
  # cluster_addons = {
  #   coredns                = {}
  #   eks-pod-identity-agent = {}
  #   kube-proxy             = {}
  #   vpc-cni                = {}
  # }

  vpc_id     = data.aws_vpc.vpc_cidr.id
  subnet_ids = [
    data.aws_subnet.private.id,
    data.aws_subnet.public.id 
  ]

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "barg-node-group-1"

      instance_types = ["t2.micro"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
}
