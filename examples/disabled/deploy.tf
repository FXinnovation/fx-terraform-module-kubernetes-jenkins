#####
# Providers
#####

provider "random" {
  version = "~> 2"
}

provider "kubernetes" {
  load_config_file = true
}

#####
# Module
#####

module "this" {
  source = "../.."

  enabled = false
}
