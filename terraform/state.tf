##https://app.terraform.io/app
terraform {
  backend "remote" {
    organization = "jameseckersall"

    workspaces {
      prefix = "terraform-"
    }
  }
}
