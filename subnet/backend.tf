terraform {
  cloud {

    organization = "boon-tfc"

    workspaces {
      name = "subnet-workspace"
    }
  }
}