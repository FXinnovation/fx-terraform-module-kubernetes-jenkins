variable "region" {
  description = "Aws region for deploying the module"
  default     = "us-east-2"
}

variable "cluster_name" {
  description = "Name of the eks cluster"
  type        = "string"
}

variable "keypair-name" {
  description = "Name of the ssh key pair to deploy on worker nodes"
  type        = "string"
}