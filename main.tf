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

resource "aws_s3_bucket_object" "object" {
  bucket = data.aws_s3_bucket.bucket.bucket  # Reference the existing bucket
  key    = "main.tf"
  source = "/Users/devops-workshop-barg/tfWix/main.tf"
  etag   = filemd5("/Users/devops-workshop-barg/tfWix/main.tf")
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0"

  cluster_name    = "barg-cluster"
  cluster_version = "1.29"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  # EKS Addons I dont know yet what it is
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

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
