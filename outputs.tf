#####
# Global
#####

output "namespace_name" {
  value = var.enabled ? var.namespace : ""
}

#####
# Statefulset
#####

output "statefulset" {
  value = element(concat(kubernetes_stateful_set.this.*, list({})), 0)
}

#####
# Service
#####

output "service" {
  value = element(concat(kubernetes_service.this.*, list({})), 0)
}

#####
# Ingress
#####

output "ingress" {
  value = element(concat(kubernetes_ingress.this.*, list({})), 0)
}

#####
# RBAC
#####

output "service_account" {
  value = element(concat(kubernetes_service_account.this.*, list({})), 0)
}

output "role" {
  value = element(concat(kubernetes_role.this.*, list({})), 0)
}

output "role_binding" {
  value = element(concat(kubernetes_role_binding.this.*, list({})), 0)
}
