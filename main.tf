resource "kubernetes_service_account" "efs" {
  count = var.efs_enabled == "true" ? 1 : 0
  metadata {
    name      = "efs-provisioner"
    namespace = var.jenkins_namespace
  }
}

resource "kubernetes_cluster_role" "this" {
  count = var.efs_enabled == "true" ? 1 : 0
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
  count = var.efs_enabled == "true" ? 1 : 0
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
  count = var.efs_enabled == "true" ? 1 : 0
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
  count = var.efs_enabled == "true" ? 1 : 0
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
  count = var.efs_enabled == "true" ? 1 : 0
  metadata {
    name = "efs-provisioner"
  }

  data = {
    "file.system.id"   = var.efs_id
    "aws.region"       = var.region
    "provisioner.name" = "example.com/aws-efs"
    "dns.name"         = var.efs_dns_name
  }
}

resource "kubernetes_storage_class" "this" {
  count = var.efs_enabled == "true" ? 1 : 0
  metadata {
    name = "aws-efs"
  }
  storage_provisioner = "example.com/aws-efs"
}

resource "kubernetes_persistent_volume_claim" "this" {
  metadata {
    name = var.jenkins_claim_name
    annotations = {
      "volume.beta.kubernetes.io/storage-class" = var.storage_class
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.jenkins_data_size
      }
    }
  }
}

resource "kubernetes_role" "jenkins" {
  metadata {
    name = var.jenkins_role_name
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

  dynamic "rule" {
    for_each = var.jenkins_role_rules
    content {
      api_groups = [rule.value.api_groups]
      resources  = [rule.value.resources]
      verbs      = [rule.value.verbs]
    }
  }
}

resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.jenkins_service_account
    namespace = var.jenkins_namespace
  }
}

resource "kubernetes_role_binding" "jenkins" {
  metadata {
    name = var.jenkins_role_binding
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = var.jenkins_role_binding
  }
  subject {
    kind      = "ServiceAccount"
    name      = var.jenkins_service_account
    namespace = var.jenkins_namespace
  }
}

resource "kubernetes_deployment" "efs" {
  count = var.efs_enabled == "true" ? 1 : 0
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
            server = var.efs_dns_name
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "this" {
  depends_on = ["kubernetes_deployment.efs"]
  metadata {
    name      = var.jenkins_deployment_name
    namespace = var.jenkins_namespace
  }

  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = var.jenkins_deployment_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.jenkins_deployment_name
        }
      }

      spec {
        service_account_name            = var.jenkins_service_account
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
            claim_name = var.jenkins_claim_name
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
    annotations = var.jenkins_ingress_annotations
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
