provider "aws" {
  version    = "~> 2.7.0"
  region     = "us-east-2"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

provider "random" {
  version = "~> 2.0"
}

data "aws_eks_cluster_auth" "this" {
  name = "fxinnovation-validation-cluster"
}

data "aws_eks_cluster" "this" {
  name = "fxinnovation-validation-cluster"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
}

resource "random_string" "this" {
  length  = 8
  special = false
  upper   = false
  number  = false
}

data "aws_efs_file_system" "this" {
  file_system_id = "fs-41426038"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.default.id
}

module "standard" {
  source = "../../"

  cluster_name            = "fxinnovation-validation-cluster"
  storage_class           = "aws-efs"
  jenkins_data_size       = "1Gi"
  jenkins_role_name       = "jenkins-${random_string.this.result}"
  efs_dns_name            = data.aws_efs_file_system.this.dns_name
  efs_id                  = data.aws_efs_file_system.this.id
  jenkins_service_account = "jenkins-${random_string.this.result}"
  aws_subnet_ids          = data.aws_subnet_ids.this.ids
  jenkins_role_binding    = "jenkins-${random_string.this.result}"
  jenkins_deployment_name = "jenkins-${random_string.this.result}"
  jenkins_claim_name      = "efs-${random_string.this.result}"
  jenkins_ingress_name    = "jenkins-${random_string.this.result}"
  region                  = "us-east-2"
  efs_enabled             = "true"
  jenkins_ingress_annotations = {
    "kubernetes.io/ingress.class"                = "alb"
    "alb.ingress.kubernetes.io/scheme"           = "internal"
    "alb.ingress.kubernetes.io/subnets"          = join(", ", data.aws_subnet_ids.this.ids)
    "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\":80}]"
    "alb.ingress.kubernetes.io/healthcheck-path" = "/"
    "alb.ingress.kubernetes.io/success-codes"    = "200,404"
  }
  jenkins_role_rules = [
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
}
