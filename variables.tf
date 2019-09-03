variable "region" {
  description = "Aws region for deploying the module"
  default     = "us-east-2"
}

variable "account_id" {
  description = "ID of the aws account"
  type        = "string"
}

variable "cluster_name" {
  description = "Name of the eks cluster"
  type        = "string"
}
