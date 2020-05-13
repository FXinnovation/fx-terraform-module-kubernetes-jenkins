#####
# Providers
#####

provider "random" {
  version = "~> 2"
}

provider "kubernetes" {
  version          = "1.10.0"
  load_config_file = true
}

#####
# Module
#####

module "this" {
  source = "../.."

  enabled = false
}
