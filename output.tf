output "efs_id" {
  value = aws_efs_file_system.this.id
}

output "ingressaddr" {
  value = data.external.ingress_public_ip.result
}

output "workers-sg" {
  value = module.eks.worker-sg
}