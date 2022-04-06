# terraform-module-kubernetes-jenkins

Terraform module to deploy jenkins on kubernetes

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 1.10.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 1.10.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_ingress.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress) | resource |
| [kubernetes_role.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role) | resource |
| [kubernetes_role_binding.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_service.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service_account.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [kubernetes_stateful_set.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) | resource |
| [random_string.selector](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additionnal_ingress_paths"></a> [additionnal\_ingress\_paths](#input\_additionnal\_ingress\_paths) | A list of map of additionnal ingress path to add. Map must support the following structure:<br>  * service\_name (optional, string): The name of the kubernates service. (e.g. ssl-redirect)<br>  * service\_port (optional, string): The service port number (e.g. use-annotation).<br>  * path (optional, string): The path to the service<br><br>For example, see folder examples/without-pvc. | `list(any)` | `[]` | no |
| <a name="input_annotations"></a> [annotations](#input\_annotations) | Map of annotations that will be applied on all resources. | `map` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether or not to enable this module. | `bool` | `true` | no |
| <a name="input_image"></a> [image](#input\_image) | Image to use. | `string` | `"fxinnovation/jenkins"` | no |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | Version of the image to use. | `string` | `"3.38.0"` | no |
| <a name="input_ingress_annotations"></a> [ingress\_annotations](#input\_ingress\_annotations) | Map of annotations that will be applied on the ingress. | `map` | `{}` | no |
| <a name="input_ingress_enabled"></a> [ingress\_enabled](#input\_ingress\_enabled) | Whether or not to enable the ingress. | `bool` | `true` | no |
| <a name="input_ingress_host"></a> [ingress\_host](#input\_ingress\_host) | Host on which the ingress wil be available (ex: nexus.example.com). | `string` | `"example.com"` | no |
| <a name="input_ingress_labels"></a> [ingress\_labels](#input\_ingress\_labels) | Map of labels that will be applied on the ingress. | `map` | `{}` | no |
| <a name="input_ingress_name"></a> [ingress\_name](#input\_ingress\_name) | Name of the ingress. | `string` | `"jenkins"` | no |
| <a name="input_ingress_tls_enabled"></a> [ingress\_tls\_enabled](#input\_ingress\_tls\_enabled) | Whether or not TLS should be enabled on the ingress. | `bool` | `true` | no |
| <a name="input_ingress_tls_secret_name"></a> [ingress\_tls\_secret\_name](#input\_ingress\_tls\_secret\_name) | Name of the secret to use to put TLS on the ingress. | `string` | `"jenkins"` | no |
| <a name="input_jnlp_port"></a> [jnlp\_port](#input\_jnlp\_port) | Port that will be set on the kubernetes resources for the JNLP connection. *Still has to be managed in the application.* | `number` | `50000` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Map of labels that will be applied on all resources. | `map` | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Name of the namespace in which to deploy the module. | `string` | `"default"` | no |
| <a name="input_resources_limits_cpu"></a> [resources\_limits\_cpu](#input\_resources\_limits\_cpu) | Amount of cpu time that the application limits. | `string` | `"2"` | no |
| <a name="input_resources_limits_memory"></a> [resources\_limits\_memory](#input\_resources\_limits\_memory) | Amount of memory that the application limits. | `string` | `"4096Mi"` | no |
| <a name="input_resources_requests_cpu"></a> [resources\_requests\_cpu](#input\_resources\_requests\_cpu) | Amount of cpu time that the application requests. | `string` | `"1"` | no |
| <a name="input_resources_requests_memory"></a> [resources\_requests\_memory](#input\_resources\_requests\_memory) | Amount of memory that the application requests. | `string` | `"2048Mi"` | no |
| <a name="input_role_additionnal_rules"></a> [role\_additionnal\_rules](#input\_role\_additionnal\_rules) | List of objects representing additionnal rules to add on the role. *All fields are required.* | <pre>list(<br>    object({<br>      api_groups     = list(string) # List of api_groups to apply the verbs on<br>      resources      = list(string) # List of resources to apply the verbs on<br>      resource_names = list(string) # List of the resource names to apply the verbs on<br>      verbs          = list(string) # List of verbs to apply<br>    })<br>  )</pre> | `[]` | no |
| <a name="input_role_annotations"></a> [role\_annotations](#input\_role\_annotations) | Map of annotations that is merged on the role. | `map` | `{}` | no |
| <a name="input_role_binding_annotations"></a> [role\_binding\_annotations](#input\_role\_binding\_annotations) | Map of annotations that is merged on the role binding | `map` | `{}` | no |
| <a name="input_role_binding_labels"></a> [role\_binding\_labels](#input\_role\_binding\_labels) | Map of labels that is merged on the role binding | `map` | `{}` | no |
| <a name="input_role_binding_name"></a> [role\_binding\_name](#input\_role\_binding\_name) | Name of the role binding for jenkins | `string` | `"jenkins"` | no |
| <a name="input_role_labels"></a> [role\_labels](#input\_role\_labels) | Map of labels that is merged on the role. | `map` | `{}` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the role. | `string` | `"jenkins"` | no |
| <a name="input_service_account_annotations"></a> [service\_account\_annotations](#input\_service\_account\_annotations) | Map of annotations that is merged on the service account. | `map` | `{}` | no |
| <a name="input_service_account_labels"></a> [service\_account\_labels](#input\_service\_account\_labels) | Map of labels that is merged on the service account. | `map` | `{}` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the service account that run jenkins | `string` | `"jenkins"` | no |
| <a name="input_service_annotations"></a> [service\_annotations](#input\_service\_annotations) | Map of annotations that will be applied on the service. | `map` | `{}` | no |
| <a name="input_service_labels"></a> [service\_labels](#input\_service\_labels) | Map of labels that will be applied on the service. | `map` | `{}` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the service. | `string` | `"jenkins"` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | Type of service to create. | `string` | `"ClusterIP"` | no |
| <a name="input_stateful_set_annotations"></a> [stateful\_set\_annotations](#input\_stateful\_set\_annotations) | Map of annotations that will be applied on the statefulset. | `map` | `{}` | no |
| <a name="input_stateful_set_automount_service_account_token"></a> [stateful\_set\_automount\_service\_account\_token](#input\_stateful\_set\_automount\_service\_account\_token) | Whether or not to mount the service account token in the pods. | `bool` | `true` | no |
| <a name="input_stateful_set_init_container_enabled"></a> [stateful\_set\_init\_container\_enabled](#input\_stateful\_set\_init\_container\_enabled) | Whether or not to use the init-container or not. The init container is used to chown the data, which is safer, but on bigger Jenkins's this can take a while. | `bool` | `true` | no |
| <a name="input_stateful_set_labels"></a> [stateful\_set\_labels](#input\_stateful\_set\_labels) | Map of labels that will be applied on the statefulset. | `map` | `{}` | no |
| <a name="input_stateful_set_name"></a> [stateful\_set\_name](#input\_stateful\_set\_name) | Name of the statefulset to deploy. | `string` | `"jenkins"` | no |
| <a name="input_stateful_set_template_annotations"></a> [stateful\_set\_template\_annotations](#input\_stateful\_set\_template\_annotations) | Map of annotations that will be applied on the statefulset template. | `map` | `{}` | no |
| <a name="input_stateful_set_template_labels"></a> [stateful\_set\_template\_labels](#input\_stateful\_set\_template\_labels) | Map of labels that will be applied on the statefulset template. | `map` | `{}` | no |
| <a name="input_stateful_set_volume_claim_template_annotations"></a> [stateful\_set\_volume\_claim\_template\_annotations](#input\_stateful\_set\_volume\_claim\_template\_annotations) | Map of annotations that will be applied on the statefulset volume claim template. | `map` | `{}` | no |
| <a name="input_stateful_set_volume_claim_template_enabled"></a> [stateful\_set\_volume\_claim\_template\_enabled](#input\_stateful\_set\_volume\_claim\_template\_enabled) | Whether or not to enable the volume claim template on the statefulset. | `bool` | `true` | no |
| <a name="input_stateful_set_volume_claim_template_labels"></a> [stateful\_set\_volume\_claim\_template\_labels](#input\_stateful\_set\_volume\_claim\_template\_labels) | Map of labels that will be applied on the statefulset volume claim template. | `map` | `{}` | no |
| <a name="input_stateful_set_volume_claim_template_name"></a> [stateful\_set\_volume\_claim\_template\_name](#input\_stateful\_set\_volume\_claim\_template\_name) | Name of the statefulset's volume claim template. | `string` | `"jenkins"` | no |
| <a name="input_stateful_set_volume_claim_template_requests_storage"></a> [stateful\_set\_volume\_claim\_template\_requests\_storage](#input\_stateful\_set\_volume\_claim\_template\_requests\_storage) | Size of storage the stateful set volume claim template requests. | `string` | `"200Gi"` | no |
| <a name="input_stateful_set_volume_claim_template_storage_class"></a> [stateful\_set\_volume\_claim\_template\_storage\_class](#input\_stateful\_set\_volume\_claim\_template\_storage\_class) | Storage class to use for the stateful set volume claim template. | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ingress"></a> [ingress](#output\_ingress) | n/a |
| <a name="output_namespace_name"></a> [namespace\_name](#output\_namespace\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
