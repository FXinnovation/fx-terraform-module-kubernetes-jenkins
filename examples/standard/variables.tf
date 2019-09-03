variable "access_key" {
  description = "Credentials: AWS access key."
  type        = "string"
}

variable "secret_key" {
  description = "Credentials: AWS secret key. Pass this as a variable, never write password in the code."
  type        = "string"
}
