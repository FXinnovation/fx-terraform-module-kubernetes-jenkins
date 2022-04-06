#####
# Providers
#####

provider "random" {}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

#####
# Module
#####

module "this" {
  source = "../.."

  enabled = false
}
