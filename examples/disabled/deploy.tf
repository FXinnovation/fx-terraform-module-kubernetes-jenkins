#####
# Providers
#####

provider "random" {
  version = "~> 2"
}

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
