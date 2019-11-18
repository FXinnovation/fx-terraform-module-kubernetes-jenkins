output "service_ui_id" {
  value = kubernetes_service.jenkins-ui.id
}

output "service_ui_port" {
  value = kubernetes_service.jenkins-ui.spec[0].port
}

output "service_ui_node_port" {
  value = kubernetes_service.jenkins-ui.spec[0].port[0].node_port
}

output "service_discovery_id" {
  value = kubernetes_service.jenkins-discovery.id
}

output "service_discovery_port" {
  value = kubernetes_service.jenkins-discovery.spec[0].port
}

output "service_ingress_addr" {
  value = kubernetes_ingress.this.load_balancer_ingress
}
