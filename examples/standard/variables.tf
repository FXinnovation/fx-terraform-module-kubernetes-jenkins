variable "access_key" {
  description = "Credentials: AWS access key."
  type        = "string"
}

variable "secret_key" {
  description = "Credentials: AWS secret key. Pass this as a variable, never write password in the code."
  type        = "string"
}

variable "aws_subnet_ids" {
  description = "IDs of the subnet where ingress is deployed"
  default     = []
}
