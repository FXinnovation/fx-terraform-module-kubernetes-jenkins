provider "aws" {
  version    = "~> 2.7.0"
  region     = "us-east-2"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

module "standard" {
  source = "../../"

  cluster_name = "terraform-jenkins"
  keypair-name = "dglantenay"
}
