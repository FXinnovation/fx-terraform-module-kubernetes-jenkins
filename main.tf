#####
# Locals
#####

locals {
  port         = 8080
  service_port = 80
  labels = {
    "version"    = var.image_version
    "part-of"    = "shared-services"
    "managed-by" = "terraform"
    "name"       = "jenkins"
  }
  annotations = {}
}

#####
# Randoms
#####

resource "random_string" "selector" {
  count = var.enabled ? 1 : 0

  special = false
  upper   = false
  number  = false
  length  = 8
}

#####
# Statefulset
#####

resource "kubernetes_stateful_set" "this" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.stateful_set_name
    namespace = var.namespace
    annotations = merge(
      local.annotations,
      var.annotations,
      var.stateful_set_annotations
    )
    labels = merge(
      {
        instance  = var.stateful_set_name
        component = "application"
      },
      local.labels,
      var.labels,
      var.stateful_set_labels
    )
  }

  spec {
    replicas     = 1
    service_name = element(concat(kubernetes_service.this.*.metadata.0.name, []), 0)

    update_strategy {
      type = "RollingUpdate"
    }

    selector {
      match_labels = {
        selector = "jenkins-${element(concat(random_string.selector.*.result, []), 0)}"
      }
    }

    template {
      metadata {
        annotations = merge(
          local.annotations,
          var.annotations,
          var.stateful_set_template_annotations
        )
        labels = merge(
          {
            instance  = var.stateful_set_name
            component = "application"
            selector  = "jenkins-${element(concat(random_string.selector.*.result, []), 0)}"
          },
          local.labels,
          var.labels,
          var.stateful_set_template_labels
        )
      }

      spec {
        automount_service_account_token = var.stateful_set_automount_service_account_token
        service_account_name            = element(concat(kubernetes_service_account.this.*.metadata.0.name, []), 0)

        dynamic "init_container" {
          for_each = var.stateful_set_volume_claim_template_enabled && var.stateful_set_init_container_enabled ? [1] : []

          content {
            name              = "init-chown-data"
            image             = "busybox:latest"
            image_pull_policy = "IfNotPresent"
            command           = ["chown", "-R", "1000:1000", "/data"]

            volume_mount {
              name       = var.stateful_set_volume_claim_template_name
              mount_path = "/data"
              sub_path   = ""
            }
          }
        }

        container {
          name              = "jenkins"
          image             = "${var.image}:${var.image_version}"
          image_pull_policy = "IfNotPresent"

          resources {
            requests {
              cpu    = var.resources_requests_cpu
              memory = var.resources_requests_memory
            }
            limits {
              cpu    = var.resources_limits_cpu
              memory = var.resources_limits_memory
            }
          }

          port {
            container_port = local.port
            protocol       = "TCP"
            name           = "http"
          }

          port {
            container_port = var.jnlp_port
            protocol       = "TCP"
            name           = "jnlp"
          }

          readiness_probe {
            http_get {
              path   = "/login"
              port   = local.port
              scheme = "HTTP"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 5
            failure_threshold     = 5
            success_threshold     = 1
            period_seconds        = 10
          }

          liveness_probe {
            http_get {
              path   = "/login"
              port   = local.port
              scheme = "HTTP"
            }

            initial_delay_seconds = 120
            timeout_seconds       = 5
            failure_threshold     = 5
            success_threshold     = 1
            period_seconds        = 10
          }

          dynamic "volume_mount" {
            for_each = var.stateful_set_volume_claim_template_enabled ? [1] : []

            content {
              name       = var.stateful_set_volume_claim_template_name
              mount_path = "/var/jenkins_home"
              sub_path   = ""
            }
          }
        }
      }
    }

    dynamic "volume_claim_template" {
      for_each = var.stateful_set_volume_claim_template_enabled ? [1] : []

      content {
        metadata {
          name      = var.stateful_set_volume_claim_template_name
          namespace = var.namespace
          annotations = merge(
            local.annotations,
            var.annotations,
            var.stateful_set_volume_claim_template_annotations
          )
          labels = merge(
            {
              instance  = var.stateful_set_volume_claim_template_name
              component = "storage"
            },
            local.labels,
            var.labels,
            var.stateful_set_volume_claim_template_labels
          )
        }

        spec {
          access_modes       = ["ReadWriteOnce"]
          storage_class_name = var.stateful_set_volume_claim_template_storage_class
          resources {
            requests = {
              storage = var.stateful_set_volume_claim_template_requests_storage
            }
          }
        }
      }
    }
  }

  # NOTE: This is needed because while documentation suggests that all labels can be changed, it seems that on VolumeClaimTemplates it is not possible to change them.
  # I create https://github.com/kubernetes/kubernetes/issues/93115 for this specific problem.
  lifecycle {
    ignore_changes = [
      spec[0].volume_claim_template[0].metadata[0].labels,
      spec[0].volume_claim_template[0].metadata[0].annotations,
    ]
  }
}

#####
# Service
#####

resource "kubernetes_service" "this" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.service_name
    namespace = var.namespace
    annotations = merge(
      local.annotations,
      var.annotations,
      var.service_annotations
    )
    labels = merge(
      {
        "instance"  = var.service_name
        "component" = "network"
      },
      local.labels,
      var.labels,
      var.service_labels
    )
  }

  spec {
    selector = {
      selector = "jenkins-${element(concat(random_string.selector.*.result, []), 0)}"
    }

    type = "ClusterIP"

    port {
      port        = local.service_port
      target_port = "http"
      protocol    = "TCP"
      name        = "http"
    }

    port {
      port        = var.jnlp_port
      target_port = "jnlp"
      protocol    = "TCP"
      name        = "jnlp"
    }
  }
}

#####
# Ingress
#####

resource "kubernetes_ingress" "this" {
  count = var.enabled && var.ingress_enabled ? 1 : 0

  metadata {
    name      = var.ingress_name
    namespace = var.namespace
    annotations = merge(
      local.annotations,
      var.annotations,
      var.ingress_annotations
    )
    labels = merge(
      {
        instance  = var.ingress_name
        component = "network"
      },
      local.labels,
      var.labels,
      var.ingress_labels
    )
  }

  spec {
    backend {
      service_name = element(concat(kubernetes_service.this.*.metadata.0.name, []), 0)
      service_port = "http"
    }

    rule {
      host = var.ingress_host
      http {
        path {
          backend {
            service_name = element(concat(kubernetes_service.this.*.metadata.0.name, []), 0)
            service_port = "http"
          }
          path = "/"
        }

        dynamic "path" {
          for_each = var.additionnal_ingress_paths

          content {
            backend {
              service_name = lookup(path.value, "service_name", element(concat(kubernetes_service.this.*.metadata.0.name, []), 0))
              service_port = lookup(path.value, "service_port", "http")
            }

            path = lookup(path.value, "path", null)
          }
        }
      }
    }

    dynamic "tls" {
      for_each = var.ingress_tls_enabled ? [1] : []

      content {
        secret_name = var.ingress_tls_secret_name
        hosts       = [var.ingress_host]
      }
    }
  }
}

#####
# RBAC
#####

resource "kubernetes_role" "this" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.role_name
    namespace = var.namespace

    annotations = merge(
      local.annotations,
      var.annotations,
      var.role_annotations
    )

    labels = merge(
      local.labels,
      var.labels,
      var.role_labels
    )
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
    for_each = var.role_additionnal_rules
    content {
      api_groups     = rule.value.api_groups
      resources      = rule.value.resources
      resource_names = rule.value.resource_names
      verbs          = rule.value.verbs
    }
  }
}

resource "kubernetes_service_account" "this" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.service_account_name
    namespace = var.namespace

    annotations = merge(
      local.annotations,
      var.annotations,
      var.service_account_annotations
    )

    labels = merge(
      local.labels,
      var.labels,
      var.service_account_annotations
    )
  }
}

resource "kubernetes_role_binding" "this" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.role_binding_name
    namespace = var.namespace

    annotations = merge(
      local.annotations,
      var.annotations,
      var.role_binding_annotations
    )
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = element(concat(kubernetes_role.this.*.metadata.0.name, []), 0)
  }

  subject {
    kind      = "ServiceAccount"
    name      = element(concat(kubernetes_service_account.this.*.metadata.0.name, []), 0)
    namespace = var.namespace
  }
}
