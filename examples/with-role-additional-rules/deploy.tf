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
# Randoms
#####

resource "random_string" "this" {
  upper   = false
  number  = false
  special = false
  length  = 8
}

#####
# Context
#####

resource "kubernetes_namespace" "this" {
  metadata {
    name = random_string.this.result
  }
}

#####
# Module
#####

module "this" {
  source = "../.."

  namespace = kubernetes_namespace.this.metadata.0.name

  role_additionnal_rules = [
    {
      api_groups     = [""]
      resources      = ["secrets"]
      resource_names = []
      verbs          = ["get"]
    }
  ]
}
