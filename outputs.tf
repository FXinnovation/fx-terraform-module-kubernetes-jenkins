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
  value = element(concat(kubernetes_stateful_set.this.*, []), 0)
}

#####
# Service
#####

output "service" {
  value = element(concat(kubernetes_service.this.*, []), 0)
}

#####
# Ingress
#####

output "ingress" {
  value = element(concat(kubernetes_ingress.this.*, []), 0)
}

#####
# RBAC
#####

output "service_account" {
  value = element(concat(kubernetes_service_account.this.*, []), 0)
}

output "role" {
  value = element(concat(kubernetes_role.this.*, []), 0)
}

output "role_binding" {
  value = element(concat(kubernetes_role_binding.this.*, []), 0)
}
