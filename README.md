# terraform-module-kubernetes-jenkins

Terraform module to deploy jenkins on kubernetes

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| claim\_name | Name of the persistent volume claim for jenkins | string | n/a | yes |
| cluster\_name | Name of the eks cluster | string | n/a | yes |
| container\_name | Name of the jenkins container | string | n/a | yes |
| deployment\_name | Name of the jenkins deployment | string | n/a | yes |
| ingress\_annotations | Map of annotations to add to the ingress service | map | `{}` | no |
| ingress\_labels | Labels applied to the ingress service | string | `"jenkins"` | no |
| ingress\_name | Name of the ingress service for jenkins | string | n/a | yes |
| namespace | Name of the namespace where jenkins is deployed | string | `"default"` | no |
| role\_binding\_name | Name of the role binding for jenkins | string | n/a | yes |
| role\_name | Name of the jenkins role | string | n/a | yes |
| role\_rules | Maps of rules to dynamically add to jenkins role | list | `[]` | no |
| service\_account\_name | Name of the service account that run jenkins | string | n/a | yes |
| service\_discovery\_name | Name of the jenkins discovery service | string | n/a | yes |
| service\_ui\_name | Name of the jenkins ui service | string | n/a | yes |
| storage\_class | Name of the storage class to use for pvc | string | n/a | yes |
| storage\_size | Size of the persistent volume used to store jenkins data | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| service\_discovery\_id |  |
| service\_discovery\_port |  |
| service\_ingress\_addr |  |
| service\_ui\_id |  |
| service\_ui\_port |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
