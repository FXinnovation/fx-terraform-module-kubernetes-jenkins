variable "cluster_name" {
  description = "Name of the eks cluster"
  type        = "string"
}

variable "storage_class" {
  description = "Name of the storage class to use for pvc"
  type        = "string"
}

variable "storage_size" {
  description = "Size of the persistent volume used to store jenkins data"
  type        = "string"
}

variable "role_name" {
  description = "Name of the jenkins role"
  type        = "string"
}

variable "service_account_name" {
  description = "Name of the service account that run jenkins"
  type        = "string"
}

variable "role_binding_name" {
  description = "Name of the role binding for jenkins"
  type        = "string"
}

variable "namespace" {
  description = "Name of the namespace where jenkins is deployed"
  default     = "default"
}

variable "role_rules" {
  description = "Maps of rules to dynamically add to jenkins role"
  default     = []
}

variable "deployment_name" {
  description = "Name of the jenkins deployment"
  type        = "string"
}

variable "claim_name" {
  description = "Name of the persistent volume claim for jenkins"
  type        = "string"
}

variable "ingress_name" {
  description = "Name of the ingress service for jenkins"
  type        = "string"
}

variable "ingress_annotations" {
  description = "Map of annotations to add to the ingress service"
  default     = {}
}

variable "ingress_labels" {
  description = "Labels applied to the ingress service"
  default     = "jenkins"
}

variable "container_name" {
  description = "Name of the jenkins container"
  type        = "string"
}

variable "service_discovery_name" {
  description = "Name of the jenkins discovery service"
  type        = "string"
}

variable "service_ui_name" {
  description = "Name of the jenkins ui service"
  type        = "string"
}
