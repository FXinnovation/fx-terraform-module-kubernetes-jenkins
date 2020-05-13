#####
# Global
#####

variable "enabled" {
  description = "Whether or not to enable this module."
  default     = true
}

variable "namespace" {
  description = "Name of the namespace in which to deploy the module."
  default     = "default"
}

variable "annotations" {
  description = "Map of annotations that will be applied on all resources."
  default     = {}
}

variable "labels" {
  description = "Map of labels that will be applied on all resources."
  default     = {}
}

#####
# Application
#####

variable "image" {
  description = "Image to use."
  default     = "fxinnovation/jenkins"
}

variable "image_version" {
  description = "Version of the image to use."
  default     = "3.37.0"
}

variable "resources_requests_cpu" {
  description = "Amount of cpu time that the application requests."
  default     = "1"
}

variable "resources_requests_memory" {
  description = "Amount of memory that the application requests."
  default     = "2048Mi"
}

variable "resources_limits_cpu" {
  description = "Amount of cpu time that the application limits."
  default     = "2"
}

variable "resources_limits_memory" {
  description = "Amount of memory that the application limits."
  default     = "4096Mi"
}

variable "jnlp_port" {
  description = "Port that will be set on the kubernetes resources for the JNLP connection. *Still has to be managed in the application.*"
  default     = 50000
}

#####
# StatefulSet
#####

variable "stateful_set_name" {
  description = "Name of the statefulset to deploy."
  default     = "jenkins"
}

variable "stateful_set_annotations" {
  description = "Map of annotations that will be applied on the statefulset."
  default     = {}
}

variable "stateful_set_labels" {
  description = "Map of labels that will be applied on the statefulset."
  default     = {}
}

variable "stateful_set_template_annotations" {
  description = "Map of annotations that will be applied on the statefulset template."
  default     = {}
}

variable "stateful_set_template_labels" {
  description = "Map of labels that will be applied on the statefulset template."
  default     = {}
}

variable "stateful_set_volume_claim_template_enabled" {
  description = "Whether or not to enable the volume claim template on the statefulset."
  default     = true
}

variable "stateful_set_volume_claim_template_annotations" {
  description = "Map of annotations that will be applied on the statefulset volume claim template."
  default     = {}
}

variable "stateful_set_volume_claim_template_labels" {
  description = "Map of labels that will be applied on the statefulset volume claim template."
  default     = {}
}

variable "stateful_set_volume_claim_template_name" {
  description = "Name of the statefulset's volume claim template."
  default     = "jenkins"
}

variable "stateful_set_volume_claim_template_storage_class" {
  description = "Storage class to use for the stateful set volume claim template."
  default     = null
}

variable "stateful_set_volume_claim_template_requests_storage" {
  description = "Size of storage the stateful set volume claim template requests."
  default     = "200Gi"
}

#####
# Service
#####

variable "service_name" {
  description = "Name of the service."
  default     = "jenkins"
}

variable "service_annotations" {
  description = "Map of annotations that will be applied on the service."
  default     = {}
}

variable "service_labels" {
  description = "Map of labels that will be applied on the service."
  default     = {}
}

#####
# Ingress
#####

variable "ingress_enabled" {
  description = "Whether or not to enable the ingress."
  default     = true
}

variable "ingress_name" {
  description = "Name of the ingress."
  default     = "jenkins"
}

variable "ingress_annotations" {
  description = "Map of annotations that will be applied on the ingress."
  default     = {}
}

variable "ingress_labels" {
  description = "Map of labels that will be applied on the ingress."
  default     = {}
}

variable "ingress_host" {
  description = "Host on which the ingress wil be available (ex: nexus.example.com)."
  default     = "example.com"
}

variable "ingress_tls_enabled" {
  description = "Whether or not TLS should be enabled on the ingress."
  default     = true
}

variable "ingress_tls_secret_name" {
  description = "Name of the secret to use to put TLS on the ingress."
  default     = "jenkins"
}

#####
# RBAC
#####

variable "role_additionnal_rules" {
  description = "List of objects representing additionnal rules to add on the role. *All fields are required.*"
  type = list(
    object({
      api_groups     = list(string) # List of api_groups to apply the verbs on
      resources      = list(string) # List of resources to apply the verbs on
      resource_names = list(string) # List of the resource names to apply the verbs on
      verbs          = list(string) # List of verbs to apply
    })
  )
  default = []
}

variable "role_name" {
  description = "Name of the role."
  default     = "jenkins"
}

variable "role_annotations" {
  description = "Map of annotations that is merged on the role."
  default     = {}
}

variable "role_labels" {
  description = "Map of labels that is merged on the role."
  default     = {}
}

variable "service_account_annotations" {
  description = "Map of annotations that is merged on the service account."
  default     = {}
}

variable "service_account_labels" {
  description = "Map of labels that is merged on the service account."
  default     = {}
}

variable "service_account_name" {
  description = "Name of the service account that run jenkins"
  default     = "jenkins"
}

variable "role_binding_annotations" {
  description = "Map of annotations that is merged on the role binding"
  default     = {}
}

variable "role_binding_labels" {
  description = "Map of labels that is merged on the role binding"
  default     = {}
}

variable "role_binding_name" {
  description = "Name of the role binding for jenkins"
  default     = "jenkins"
}
