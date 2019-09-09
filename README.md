# terraform-module-kubernetes-jenkins

Terraform module to deploy jenkins on kubernetes

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_subnet\_ids | IDs of the subnet where ingres is deployed | list | `[]` | no |
| cluster\_name | Name of the eks cluster | string | n/a | yes |
| efs\_dns\_name | DNS name to access efs | string | n/a | yes |
| efs\_enabled | Boolean that indicates if efs will be use by the cluster | string | `"false"` | no |
| efs\_id | ID of the efs file system to use for pvc | string | n/a | yes |
| jenkins\_claim\_name | Name of the persistent volume claim for jenkins | string | n/a | yes |
| jenkins\_data\_size | Size of the persistent volume used to store jenkins data | string | n/a | yes |
| jenkins\_deployment\_name | Name of the jenkins deployment | string | n/a | yes |
| jenkins\_ingress\_annotations | Map of annotations to add to the ingress service | map | `{}` | no |
| jenkins\_ingress\_name | Name of the ingress service for jenkins | string | n/a | yes |
| jenkins\_namespace | Name of the namespace where jenkins is deployed | string | `"default"` | no |
| jenkins\_role\_binding | Name of the role binding for jenkins | string | n/a | yes |
| jenkins\_role\_name | Name of the jenkins role | string | n/a | yes |
| jenkins\_role\_rules | Maps of tags to dynamically add to autoscaling group | list | `[]` | no |
| jenkins\_service\_account | Name of the service account that run jenkins | string | n/a | yes |
| region | Aws region for deploying the module | string | n/a | yes |
| storage\_class | Name of the storage class to use for pvc | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| service\_discovery\_id |  |
| service\_discovery\_port |  |
| service\_ingress\_addr |  |
| service\_ui\_id |  |
| service\_ui\_port |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
