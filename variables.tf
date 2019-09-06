variable "region" {
  description = "Aws region for deploying the module"
  type        = "string"
}

variable "cluster_name" {
  description = "Name of the eks cluster"
  type        = "string"
}

variable "efs_enabled" {
  description = "Boolean that indicates if efs will be use by the cluster"
  default     = "false"
}

variable "efs_id" {
  description = "ID of the efs file system to use for pvc"
  type        = "string"
}

variable "efs_dns_name" {
  description = "DNS name to access efs"
  type        = "string"
}

variable "storage_class" {
  description = "Name of the storage class to use for pvc"
  type        = "string"
}

variable "jenkins_data_size" {
  description = "Size of the persistent volume used to store jenkins data"
  type        = "string"
}

variable "jenkins_role_name" {
  description = "Name of the jenkins role"
  type        = "string"
}

variable "jenkins_service_account" {
  description = "Name of the service account that run jenkins"
  type        = "string"
}

variable "jenkins_role_binding" {
  description = "Name of the role binding for jenkins"
  type        = "string"
}

variable "jenkins_namespace" {
  description = "Name of the namespace where jenkins is deployed"
  default     = "default"
}

variable "aws_subnet_ids" {
  description = "IDs of the subnet where ingres is deployed"
  default     = []
}

variable "jenkins_role_rules" {
  description = "Maps of tags to dynamically add to autoscaling group"
  default     = []
}

variable "jenkins_deployment_name" {
  description = "Name of the jenkins deployment"
  type        = "string"
}

variable "jenkins_claim_name" {
  description = "Name of the persistent volume claim for jenkins"
  type        = "string"
}

variable "jenkins_ingress_name" {
  description = "Name of the ingress service for jenkins"
  type        = "string"
}

variable "jenkins_ingress_annotations" {
  description = "Map of annotations to add to the ingress service"
  default     = {}
}
