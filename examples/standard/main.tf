resource "random_string" "this" {
  length  = 8
  special = false
  upper   = false
  number  = false
}

module "standard" {
  source = "../../"

  namespace_creation     = false
  storage_class          = "standard"
  storage_size           = "4Gi"
  role_name              = "jenkins-${random_string.this.result}"
  service_account_name   = "jenkins-${random_string.this.result}"
  role_binding_name      = "jenkins-${random_string.this.result}"
  deployment_name        = "jenkins-${random_string.this.result}"
  claim_name             = "efs-${random_string.this.result}"
  claim_wait_until_bound = false
  ingress_name           = "jenkins-${random_string.this.result}"
  ingress_annotations    = {}
  role_rules = [
    {
      api_groups = ""
      resources  = "roles"
      verbs      = "get"
    },
    {
      api_groups = ""
      resources  = "rolebindings"
      verbs      = "get"
    }
  ]
  container_name         = "jenkins-master-${random_string.this.result}"
  service_discovery_name = "jenkins-discovery-${random_string.this.result}"
  service_ui_name        = "jenkins-ui-${random_string.this.result}"
  cpu_max                = "0.5"
  cpu_request            = "0.25"
  memory_max             = "256Mi"
  memory_request         = "128Mi"
}
