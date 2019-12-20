variable "namespace_creation" {
  description = "Create the namespace. This is mandatory will this PR isn't merged https://github.com/terraform-providers/terraform-provider-kubernetes/issues/613"
  type        = bool
  default     = true
}

variable "storage_class" {
  description = "Name of the storage class to use for pvc"
  type        = string
}

variable "storage_size" {
  description = "Size of the persistent volume used to store jenkins data"
  type        = string
}

variable "role_name" {
  description = "Name of the jenkins role"
  type        = string
}

variable "service_account_name" {
  description = "Name of the service account that run jenkins"
  type        = string
}

variable "role_binding_name" {
  description = "Name of the role binding for jenkins"
  type        = string
}

variable "namespace" {
  description = "Name of the namespace where jenkins is deployed"
  default     = "default"
}

variable "role_rules" {
  description = "List of maps of rules to dynamically add to jenkins role"
  default     = []
}

variable "deployment_name" {
  description = "Name of the jenkins deployment"
  type        = string
}

variable "claim_name" {
  description = "Name of the persistent volume claim for jenkins"
  type        = string
}

variable "ingress_name" {
  description = "Name of the ingress service for jenkins"
  type        = string
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
  type        = string
}

variable "service_discovery_name" {
  description = "Name of the jenkins discovery service"
  type        = string
}

variable "service_ui_name" {
  description = "Name of the jenkins ui service"
  type        = string
}

variable "cpu_max" {
  description = "Maximum number of cpu that can be used by jenkins"
  default     = "3"
}

variable "cpu_request" {
  description = "Requested number of cpu for jenkins"
  default     = "2"
}

variable "memory_max" {
  description = "Maximum amount of ram that can be used by jenkins"
  default     = "6144Mi"
}

variable "memory_request" {
  description = "Requested amount of ram for jenkins"
  default     = "4096Mi"
}

variable "docker_image" {
  description = "Name of the docker image to use for jenkins"
  default     = "fxinnovation/jenkins:3.33.0"
}
