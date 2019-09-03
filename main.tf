data "aws_vpc" "this" {
  default = true
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.this.id
}

resource "aws_efs_file_system" "this" {
  encrypted = true

  tags = {
    Name = "terraform-eks"
  }
}

resource "aws_efs_mount_target" "this" {
  count          = length(data.aws_subnet_ids.this.ids)
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = tolist(data.aws_subnet_ids.this.ids)[count.index]
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "external" "aws_iam_authenticator" {
  program = ["sh", "-c", "aws-iam-authenticator token -i ${var.cluster_name} | jq -r -c .status"]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.external.aws_iam_authenticator.result.token
  load_config_file       = false
  version                = "~> 1.13"
}

resource "kubernetes_service_account" "efs" {
  metadata {
    name      = "efs-provisioner"
    namespace = "default"
  }
}

resource "kubernetes_cluster_role" "this" {
  metadata {
    name = "efs-provisioner-runner"
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumes"]
    verbs      = ["get", "list", "watch", "create", "delete"]
  }
  rule {
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
    verbs      = ["get", "list", "watch", "update"]
  }
  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "update", "patch"]
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = "run-efs-provisioner"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "efs-provisioner-runner"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "efs-provisioner"
    namespace = "default"
  }
}

resource "kubernetes_role" "this" {
  metadata {
    name = "leader-locking-efs-provisioner"
  }

  rule {
    api_groups = [""]
    resources  = ["endpoints"]
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
  }
}

resource "kubernetes_role_binding" "this" {
  metadata {
    name = "leader-locking-efs-provisioner"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "leader-locking-efs-provisioner"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "efs-provisioner"
    namespace = "default"
  }
}

resource "kubernetes_config_map" "this" {
  metadata {
    name = "efs-provisioner"
  }

  data = {
    "file.system.id"   = aws_efs_file_system.this.id
    "aws.region"       = var.region
    "provisioner.name" = "example.com/aws-efs"
    "dns.name"         = aws_efs_file_system.this.dns_name
  }
}

resource "kubernetes_storage_class" "this" {
  metadata {
    name = "aws-efs"
  }
  storage_provisioner = "example.com/aws-efs"
}

resource "kubernetes_persistent_volume_claim" "this" {
  metadata {
    name = "efs"
    annotations = {
      "volume.beta.kubernetes.io/storage-class" = "aws-efs"
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "kubernetes_role" "jenkins" {
  metadata {
    name = "jenkins"
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/log"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get"]
  }
}

resource "kubernetes_service_account" "this" {
  metadata {
    name      = "jenkins"
    namespace = "default"
  }
}

resource "kubernetes_role_binding" "jenkins" {
  metadata {
    name = "jenkins"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "jenkins"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "jenkins"
    namespace = "default"
  }
}

resource "kubernetes_deployment" "efs" {
  depends_on = ["aws_efs_file_system.this", "aws_efs_mount_target.this"]
  metadata {
    name      = "efs-provisioner"
    namespace = "default"
  }

  spec {
    replicas = 2
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = "efs-provisioner"
      }
    }

    template {
      metadata {
        labels = {
          app = "efs-provisioner"
        }
      }

      spec {
        service_account_name            = "efs-provisioner"
        automount_service_account_token = true
        container {
          image = "quay.io/external_storage/efs-provisioner:latest"
          name  = "efs-provisioner"

          env {
            name = "FILE_SYSTEM_ID"
            value_from {
              config_map_key_ref {
                name = "efs-provisioner"
                key  = "file.system.id"
              }
            }
          }
          env {
            name = "AWS_REGION"
            value_from {
              config_map_key_ref {
                name = "efs-provisioner"
                key  = "aws.region"
              }
            }
          }
          env {
            name = "DNS_NAME"
            value_from {
              config_map_key_ref {
                name = "efs-provisioner"
                key  = "dns.name"
              }
            }
          }
          env {
            name = "PROVISIONER_NAME"
            value_from {
              config_map_key_ref {
                name = "efs-provisioner"
                key  = "provisioner.name"
              }
            }
          }

          volume_mount {
            mount_path = "/persistentvolumes"
            name       = "pv-volume"
          }
        }
        volume {
          name = "pv-volume"
          nfs {
            path   = "/"
            server = "${aws_efs_file_system.this.id}.efs.${var.region}.amazonaws.com"
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "this" {
  depends_on = ["kubernetes_deployment.efs"]
  metadata {
    name      = "jenkins-master"
    namespace = "default"
  }

  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = "jenkins-master"
      }
    }

    template {
      metadata {
        labels = {
          app = "jenkins-master"
        }
      }

      spec {
        service_account_name            = "jenkins"
        automount_service_account_token = true
        container {
          image = "fxinnovation/jenkins:3.33.0"
          name  = "jenkins-master"

          resources {
            limits {
              cpu    = "3"
              memory = "6144Mi"
            }
            requests {
              cpu    = "2"
              memory = "4096Mi"
            }
          }

          readiness_probe {
            http_get {
              path = "/login"
              port = 8080
            }
            initial_delay_seconds = 90
            timeout_seconds       = 5
            success_threshold     = 1
            failure_threshold     = 5
          }

          liveness_probe {
            http_get {
              path = "/login"
              port = 8080
            }
            initial_delay_seconds = 180
            timeout_seconds       = 5
            success_threshold     = 1
            failure_threshold     = 5
          }

          port {
            container_port = 8080
          }

          port {
            container_port = 50000
          }

          volume_mount {
            mount_path = "/var/jenkins_home"
            name       = "jenkins-data"
          }
        }
        volume {
          name = "jenkins-data"
          persistent_volume_claim {
            claim_name = "efs"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "jenkins-ui" {
  metadata {
    name = "jenkins-ui"
  }
  spec {
    selector = {
      app = "jenkins-master"
    }
    port {
      port        = 8080
      target_port = 8080
      name        = "ui"
      protocol    = "TCP"
    }

    type = "NodePort"
  }
}

resource "kubernetes_service" "jenkins-discovery" {
  metadata {
    name = "jenkins-discovery"
  }
  spec {
    selector = {
      app = "jenkins-master"
    }
    port {
      port        = 50000
      target_port = 50000
      name        = "slaves"
      protocol    = "TCP"
    }
  }
}

resource "kubernetes_ingress" "this" {
  metadata {
    name = "jenkins"
    labels = {
      app = "jenkins"
    }
    annotations = {
      "kubernetes.io/ingress.class"                = "alb"
      "alb.ingress.kubernetes.io/scheme"           = "internal"
      "alb.ingress.kubernetes.io/subnets"          = join(", ", data.aws_subnet_ids.this.ids)
      "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\":80}]"
      "alb.ingress.kubernetes.io/healthcheck-path" = "/"
      "alb.ingress.kubernetes.io/success-codes"    = "200,404"
    }
  }

  spec {
    rule {
      http {
        path {
          backend {
            service_name = "jenkins-ui"
            service_port = 8080
          }
        }
      }
    }
  }
}

data "external" "ingress_public_ip" {
  depends_on = ["kubernetes_ingress.this"]
  program    = ["bash", "${path.module}/ingress/public-address.sh"]
}
