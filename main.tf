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

data "aws_s3_bucket" "bucket" {
  bucket = "barg-bucket2"  # Use the correct existing bucket name
}

resource "aws_s3_object" "object" {
  bucket = data.aws_s3_bucket.bucket.bucket  # Reference the existing bucket
  key    = "terraform.tfstate"
  source = "/Users/devops-workshop-barg/wixproj/Devops_workshop/terraform.tfstate"
  etag   = filemd5("/Users/devops-workshop-barg/wixproj/Devops_workshop/terraform.tfstate")
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cider
  tags = {
    Name = "DevOps-Workshop"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_public
  availability_zone = "eu-west-1c"
  tags = {
    Name = "barg-sub1"
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_private
  availability_zone = "eu-west-1a"

  tags = {
    Name = "barg-sub2"
  }
}

resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.main.id

}

resource "aws_route_table" "PublicRT"{
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

}

resource "aws_route_table_association" "PublicRTassociation"{
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.PublicRT.id


}






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

  vpc_id     = aws_vpc.main.id
  # The subnet_ids is a array object that contain all subnets
  subnet_ids = [
    aws_subnet.public_subnet.id,
    aws_subnet.private_subnet.id
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
