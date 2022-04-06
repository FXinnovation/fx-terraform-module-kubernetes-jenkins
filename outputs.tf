#####
# Global
#####

output "namespace_name" {
  value = var.enabled ? var.namespace : ""
}

#####
# Ingress
#####

output "ingress" {
  value = var.enabled && var.ingress_enabled ? element(concat(kubernetes_ingress.this.*, [""]), 0) : null
}
