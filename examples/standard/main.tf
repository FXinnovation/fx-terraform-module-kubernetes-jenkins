resource "random_string" "this" {
  length  = 8
  special = false
  upper   = false
  number  = false
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "this" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.this.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "this" {
  private_key      = tls_private_key.this.private_key_pem
  certificate_body = tls_self_signed_cert.this.cert_pem
}

module "standard" {
  source = "../../"

  namespace_creation   = false
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
    "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\":80}, {\"HTTPS\":443}]"
    "alb.ingress.kubernetes.io/healthcheck-path" = "/"
    "alb.ingress.kubernetes.io/success-codes"    = "200,404"
    "alb.ingress.kubernetes.io/security-groups"  = ""
    "alb.ingress.kubernetes.io/certificate-arn"  = aws_acm_certificate.this.arn
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
  cpu_max                = "0.5"
  cpu_request            = "0.25"
  memory_max             = "256Mi"
  memory_request         = "128Mi"
}
