terraform {
  cloud {

    organization = "boon-tfc"

    workspaces {
      name = "vpc-workspace"
    }
  }
}