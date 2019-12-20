resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_persistent_volume_claim" "this" {
  metadata {
    name      = var.claim_name
    namespace = var.namespace
    annotations = {
      "volume.beta.kubernetes.io/storage-class" = var.storage_class
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.storage_size
      }
    }
  }
}

resource "kubernetes_role" "jenkins" {
  metadata {
    name      = var.role_name
    namespace = var.namespace
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
    for_each = var.role_rules
    content {
      api_groups = [rule.value.api_groups]
      resources  = [rule.value.resources]
      verbs      = [rule.value.verbs]
    }
  }
}

resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace
  }
}

resource "kubernetes_role_binding" "jenkins" {
  metadata {
    name = var.role_binding_name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = var.role_binding_name
  }
  subject {
    kind      = "ServiceAccount"
    name      = var.service_account_name
    namespace = var.namespace
  }
}

resource "kubernetes_deployment" "this" {
  metadata {
    name      = var.deployment_name
    namespace = var.namespace
  }

  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = var.deployment_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.deployment_name
        }
      }

      spec {
        service_account_name            = kubernetes_service_account.this.metadata[0].name
        automount_service_account_token = true
        container {
          image = var.docker_image
          name  = var.container_name

          resources {
            limits {
              cpu    = var.cpu_max
              memory = var.memory_max
            }
            requests {
              cpu    = var.cpu_request
              memory = var.memory_request
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
            claim_name = kubernetes_persistent_volume_claim.this.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "jenkins-ui" {
  metadata {
    name      = var.service_ui_name
    namespace = var.namespace
  }
  spec {
    selector = {
      app = var.deployment_name
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
    name      = var.service_discovery_name
    namespace = var.namespace
  }
  spec {
    selector = {
      app = var.deployment_name
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
    name      = var.ingress_name
    namespace = var.namespace
    labels = {
      app = var.ingress_labels
    }
    annotations = var.ingress_annotations
  }

  spec {
    rule {
      http {
        path {
          backend {
            service_name = var.service_ui_name
            service_port = 8080
          }
        }
      }
    }
  }
}
