Terraform Multi-Workspace Setup

This repository demonstrates how to use Terraform Cloud with multiple workspaces. We will create:
vpc-workspace: Creates a VPC and outputs vpc_id.
subnet-workspace: Uses terraform_remote_state to fetch vpc_id and create subnets.

Repository Structure

terraform-awsvpcnsubnet/
│── vpc/
│   ├── main.tf
│   ├── backend.tf
│   ├── versions.tf
│
│── subnet/
│   ├── main.tf
│   ├── backend.tf
│   ├── versions.tf
│
│── README.md


Setup Instructions

1️⃣ Initialize and Apply vpc-workspace
cd vpc-workspace
terraform init
terraform apply -auto-approve

This will create a VPC and output the vpc_id.

2️⃣ Authorize subnet-workspace to Read vpc-workspace State

Go to Terraform Cloud → Select vpc-workspace

General → Share with specific workspaces → subnet-workspace

3️⃣ Initialize and Apply subnet-workspace

This will retrieve the vpc_id from vpc-workspace and create subnets inside the VPC.

Terraform Configuration Details

vpc/main.tf (Creates VPC)

resource "aws_vpc" "sandbox-vpc" { #Create new custom vpc
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  provider             = aws

  tags = {
    Name   = "sandbox-vpc"
  }
}

output "vpc_id" {
  value = aws_vpc.sandbox-vpc.id
}


subnet/main.tf (Creates Subnets Using VPC ID from vpc-workspace)

data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "boon-tfc"
    workspaces = {
      name = "vpc-workspace"  # This is the workspace name that holds the VPC ID
    }
  }
}

resource "aws_subnet" "publicSubnet1" { #Create new publicSubnet
  provider                       = aws
  vpc_id                         = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block                     = "10.0.1.0/24"
  map_public_ip_on_launch        = true
  availability_zone              = "ap-southeast-1a"
  
  tags          = {
    Name        = "publicSubnet1"
    Env         = "Sandbox"
  }
}

resource "aws_subnet" "publicSubnet2" { #Create new publicSubnet
  provider                        = aws
  vpc_id                          = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block                      = "10.0.2.0/24"
  map_public_ip_on_launch         = true
  availability_zone               = "ap-southeast-1b"

  tags          = {
    Name        = "publicSubnet2"
    Env         = "Sandbox"
  }
}


Notes

Ensure both workspaces belong to the "boon-tfc" organization in Terraform Cloud.

Terraform Cloud is used as the backend for state management.

Make sure to authorize state access between workspaces.
