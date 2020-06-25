# terraform-module-kubernetes-jenkins

Terraform module to deploy jenkins on kubernetes

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| kubernetes | >= 1.10.0 |
| random | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| kubernetes | >= 1.10.0 |
| random | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| annotations | Map of annotations that will be applied on all resources. | `map` | `{}` | no |
| enabled | Whether or not to enable this module. | `bool` | `true` | no |
| image | Image to use. | `string` | `"fxinnovation/jenkins"` | no |
| image\_version | Version of the image to use. | `string` | `"3.38.0"` | no |
| ingress\_annotations | Map of annotations that will be applied on the ingress. | `map` | `{}` | no |
| ingress\_enabled | Whether or not to enable the ingress. | `bool` | `true` | no |
| ingress\_host | Host on which the ingress wil be available (ex: nexus.example.com). | `string` | `"example.com"` | no |
| ingress\_labels | Map of labels that will be applied on the ingress. | `map` | `{}` | no |
| ingress\_name | Name of the ingress. | `string` | `"jenkins"` | no |
| ingress\_tls\_enabled | Whether or not TLS should be enabled on the ingress. | `bool` | `true` | no |
| ingress\_tls\_secret\_name | Name of the secret to use to put TLS on the ingress. | `string` | `"jenkins"` | no |
| jnlp\_port | Port that will be set on the kubernetes resources for the JNLP connection. \*Still has to be managed in the application.\* | `number` | `50000` | no |
| labels | Map of labels that will be applied on all resources. | `map` | `{}` | no |
| namespace | Name of the namespace in which to deploy the module. | `string` | `"default"` | no |
| resources\_limits\_cpu | Amount of cpu time that the application limits. | `string` | `"2"` | no |
| resources\_limits\_memory | Amount of memory that the application limits. | `string` | `"4096Mi"` | no |
| resources\_requests\_cpu | Amount of cpu time that the application requests. | `string` | `"1"` | no |
| resources\_requests\_memory | Amount of memory that the application requests. | `string` | `"2048Mi"` | no |
| role\_additionnal\_rules | List of objects representing additionnal rules to add on the role. \*All fields are required.\* | <pre>list(<br>    object({<br>      api_groups     = list(string) # List of api_groups to apply the verbs on<br>      resources      = list(string) # List of resources to apply the verbs on<br>      resource_names = list(string) # List of the resource names to apply the verbs on<br>      verbs          = list(string) # List of verbs to apply<br>    })<br>  )</pre> | `[]` | no |
| role\_annotations | Map of annotations that is merged on the role. | `map` | `{}` | no |
| role\_binding\_annotations | Map of annotations that is merged on the role binding | `map` | `{}` | no |
| role\_binding\_labels | Map of labels that is merged on the role binding | `map` | `{}` | no |
| role\_binding\_name | Name of the role binding for jenkins | `string` | `"jenkins"` | no |
| role\_labels | Map of labels that is merged on the role. | `map` | `{}` | no |
| role\_name | Name of the role. | `string` | `"jenkins"` | no |
| service\_account\_annotations | Map of annotations that is merged on the service account. | `map` | `{}` | no |
| service\_account\_labels | Map of labels that is merged on the service account. | `map` | `{}` | no |
| service\_account\_name | Name of the service account that run jenkins | `string` | `"jenkins"` | no |
| service\_annotations | Map of annotations that will be applied on the service. | `map` | `{}` | no |
| service\_labels | Map of labels that will be applied on the service. | `map` | `{}` | no |
| service\_name | Name of the service. | `string` | `"jenkins"` | no |
| stateful\_set\_annotations | Map of annotations that will be applied on the statefulset. | `map` | `{}` | no |
| stateful\_set\_automount\_service\_account\_token | Whether or not to mount the service account token in the pods. | `bool` | `true` | no |
| stateful\_set\_labels | Map of labels that will be applied on the statefulset. | `map` | `{}` | no |
| stateful\_set\_name | Name of the statefulset to deploy. | `string` | `"jenkins"` | no |
| stateful\_set\_template\_annotations | Map of annotations that will be applied on the statefulset template. | `map` | `{}` | no |
| stateful\_set\_template\_labels | Map of labels that will be applied on the statefulset template. | `map` | `{}` | no |
| stateful\_set\_volume\_claim\_template\_annotations | Map of annotations that will be applied on the statefulset volume claim template. | `map` | `{}` | no |
| stateful\_set\_volume\_claim\_template\_enabled | Whether or not to enable the volume claim template on the statefulset. | `bool` | `true` | no |
| stateful\_set\_volume\_claim\_template\_labels | Map of labels that will be applied on the statefulset volume claim template. | `map` | `{}` | no |
| stateful\_set\_volume\_claim\_template\_name | Name of the statefulset's volume claim template. | `string` | `"jenkins"` | no |
| stateful\_set\_volume\_claim\_template\_requests\_storage | Size of storage the stateful set volume claim template requests. | `string` | `"200Gi"` | no |
| stateful\_set\_volume\_claim\_template\_storage\_class | Storage class to use for the stateful set volume claim template. | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| ingress | n/a |
| namespace\_name | n/a |
| role | n/a |
| role\_binding | n/a |
| service | n/a |
| service\_account | n/a |
| statefulset | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
