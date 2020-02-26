# terraform-module-kubernetes-jenkins

Terraform module to deploy jenkins on kubernetes

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| kubernetes | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| annotations | Annotations to be merged with all resources | `map` | `{}` | no |
| claim\_annotations | Annotations to be merged with jenkins persistent claim | `map` | `{}` | no |
| claim\_name | Name of the persistent volume claim for jenkins | `string` | n/a | yes |
| claim\_wait\_until\_bound | Wait volume claim creation until bound | `bool` | `true` | no |
| container\_name | Name of the jenkins container | `string` | n/a | yes |
| cpu\_max | Maximum number of cpu that can be used by jenkins | `string` | `"3"` | no |
| cpu\_request | Requested number of cpu for jenkins | `string` | `"2"` | no |
| deployment\_annotations | Annotations to be merged with the jenkins deployment | `map` | `{}` | no |
| deployment\_name | Name of the jenkins deployment | `string` | n/a | yes |
| docker\_image | Name of the docker image to use for jenkins | `string` | `"fxinnovation/jenkins:3.33.0"` | no |
| ingress\_annotations | Annotations to merged with ingress service | `map` | `{}` | no |
| ingress\_depend\_on | Force dependency on ingress | `list(string)` | `[]` | no |
| ingress\_labels | Labels applied to the ingress service | `string` | `"jenkins"` | no |
| ingress\_name | Name of the ingress service for jenkins | `string` | n/a | yes |
| ingress\_paths | Paths for jenkins ingress | `map` | <pre>{<br>  "ui": {<br>    "service_name": "jenkins-ui",<br>    "service_port": "8080"<br>  }<br>}</pre> | no |
| memory\_max | Maximum amount of ram that can be used by jenkins | `string` | `"6144Mi"` | no |
| memory\_request | Requested amount of ram for jenkins | `string` | `"4096Mi"` | no |
| namespace | Name of the namespace where jenkins is deployed | `string` | `"default"` | no |
| namespace\_creation | Create the namespace. This is mandatory will this PR isn't merged https://github.com/terraform-providers/terraform-provider-kubernetes/issues/613 | `bool` | `true` | no |
| role\_annotations | Annotations to be merged with jenkins role | `map` | `{}` | no |
| role\_binding\_annotations | Annotations to be merged with jenkins role binding | `map` | `{}` | no |
| role\_binding\_name | Name of the role binding for jenkins | `string` | n/a | yes |
| role\_name | Name of the jenkins role | `string` | n/a | yes |
| role\_rules | List of maps of rules to dynamically add to jenkins role | `list` | `[]` | no |
| service\_account\_annotations | Annotations to be merged with jenkins service account | `map` | `{}` | no |
| service\_account\_name | Name of the service account that run jenkins | `string` | n/a | yes |
| service\_discovery\_annotations | Annotations to be merged with jenkins service discovery | `map` | `{}` | no |
| service\_discovery\_name | Name of the jenkins discovery service | `string` | n/a | yes |
| service\_ui\_annotations | Annotations to be merged with jenkins ui service | `map` | `{}` | no |
| service\_ui\_name | Name of the jenkins ui service | `string` | n/a | yes |
| storage\_class | Name of the storage class to use for pvc | `string` | n/a | yes |
| storage\_size | Size of the persistent volume used to store jenkins data | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| service\_discovery\_id | n/a |
| service\_discovery\_port | n/a |
| service\_ingress\_addr | n/a |
| service\_ui\_id | n/a |
| service\_ui\_node\_port | n/a |
| service\_ui\_port | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
