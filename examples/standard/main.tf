resource "random_string" "this" {
  length  = 8
  special = false
  upper   = false
  number  = false
}

module "standard" {
  source = "../../"

  storage_class        = "aws-efs"
  storage_size         = "1Gi"
  role_name            = "jenkins-${random_string.this.result}"
  service_account_name = "jenkins-${random_string.this.result}"
  role_binding_name    = "jenkins-${random_string.this.result}"
  deployment_name      = "jenkins-${random_string.this.result}"
  claim_name           = "efs-${random_string.this.result}"
  ingress_name         = "jenkins-${random_string.this.result}"
  ingress_annotations = {
    "kubernetes.io/ingress.class"                = "alb"
    "alb.ingress.kubernetes.io/scheme"           = "internal"
    "alb.ingress.kubernetes.io/subnets"          = join(", ", data.aws_subnet_ids.this.ids)
    "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\":80}]"
    "alb.ingress.kubernetes.io/healthcheck-path" = "/"
    "alb.ingress.kubernetes.io/success-codes"    = "200,404"
  }
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
}
