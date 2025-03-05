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


# Create a new private subnet in the existing VPC
resource "aws_subnet" "private_sub" {
  vpc_id                  = data.aws_vpc.vpc_cidr.id
  cidr_block              = "192.168.17.0/24"  # Set the CIDR block for the private subnet
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false  # Private subnet doesn't assign public IP by default

  tags = {
    Name = "barg-private-subnet"
  }
}

# Create a new public subnet in the existing VPC
resource "aws_subnet" "public_sub" {
  vpc_id                  = data.aws_vpc.vpc_cidr.id
  cidr_block              = "192.168.16.0/24"  # Set the CIDR block for the public subnet
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true   # Public subnet assigns public IPs by default

  tags = {
    Name = "barg-public-subnet"
  }
}

resource "aws_internet_gateway" "devops-workshop-igw" {
  vpc_id      = data.aws_vpc.vpc_cidr.id
}
resource "aws_route_table" "BarGu_RT"{
  vpc_id      = data.aws_vpc.vpc_cidr.id

  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops-workshop-igw.id
  }

}

resource "aws_route_table_association" "barG-publicRTassociation" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.BarGu_RT.id

}

# Creating the eks module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0"

  cluster_name    = "barg-fisrt-cluster"
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
    aws_subnet.private_sub.id,
    aws_subnet.public_sub.id 
  ]

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "barg-first-node-group"

      instance_types = ["t2.micro"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
}
