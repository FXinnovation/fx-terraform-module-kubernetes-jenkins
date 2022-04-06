#####
# Providers
#####

provider "random" {}

provider "kubernetes" {
  config_path = "~/.kube/config"
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

  stateful_set_volume_claim_template_enabled = false

  additionnal_ingress_paths = [
    {
      service_name = "foo-service"
      service_port = "http"
      path         = "/"
    }
  ]
  annotations = {
    environment = random_string.this.result
  }
}
