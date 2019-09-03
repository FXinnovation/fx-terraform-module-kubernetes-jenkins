provider "aws" {
  version    = "~> 2.7.0"
  region     = "us-east-2"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

module "standard" {
  source = "../../"

  account_id   = "203977111394"
  cluster_name = "terraform-jenkins"
  secret       = "mybeautifulsecret"
}
