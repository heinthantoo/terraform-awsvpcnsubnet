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