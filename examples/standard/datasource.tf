data "aws_eks_cluster_auth" "this" {
  name = "fxinnovation-validation-cluster"
}

data "aws_eks_cluster" "this" {
  name = "fxinnovation-validation-cluster"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.default.id
}
