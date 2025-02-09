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


