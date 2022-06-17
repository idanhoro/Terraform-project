<!-- BEGIN_TF_DOCS -->
# Project description
 In this project you can build infrastructure of the WeightTracker application but instead of doing it manually we are going to use Terraform to automate this process.

# Running instructions

- Create Image using the guide : https://github.com/idanhoro/bootcamp-app
- Clone this project.
- Create `tfvars file` using the input table below.
- run `terraform apply`

## Requirements


| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.0.2 |

## Modules 

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_scale_set"></a> [app\_scale\_set](#module\_app\_scale\_set) | ../modules/scale_set_module | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_lb.webapp_load_balancer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_nat_pool.lbnatpool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_nat_pool) | resource |
| [azurerm_lb_probe.loadbalancer_probe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.lb_port_8080_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_network_security_group.nsg_private_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.nsg_public_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_postgresql_flexible_server.postgres_database_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server_configuration.db-config-no-ssl](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_private_dns_zone.private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_vnl](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_public_ip.public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_ssh_public_key.public-key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ssh_public_key) | resource |
| [azurerm_storage_blob.blob_storage_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_subnet.app_private_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.app_public_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.private_nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.public_nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.app_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | The password of the instances | `string` | n/a | yes |
| <a name="input_admin_user"></a> [admin\_user](#input\_admin\_user) | The username of the instances | `string` | n/a | yes |
| <a name="input_allowed_ip_address"></a> [allowed\_ip\_address](#input\_allowed\_ip\_address) | The ip/s are allowed to connect with ssh to the web application servers | `string` | n/a | yes |
| <a name="input_image_gallery_name"></a> [image\_gallery\_name](#input\_image\_gallery\_name) | The images's gallery name | `string` | n/a | yes |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | The image's name | `string` | n/a | yes |
| <a name="input_image_resource_group_name"></a> [image\_resource\_group\_name](#input\_image\_resource\_group\_name) | The name of the resource group associated with the image | `string` | n/a | yes |
| <a name="input_image_version_name"></a> [image\_version\_name](#input\_image\_version\_name) | String represent the image version | `string` | n/a | yes |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances to create using the scale set | `number` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | Password of the postgresql database | `string` | n/a | yes |
| <a name="input_postgres_sku_model"></a> [postgres\_sku\_model](#input\_postgres\_sku\_model) | Model of virtual machine for the database | `string` | n/a | yes |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | Username of the postgresql database | `string` | n/a | yes |
| <a name="input_private_subnet_address_space"></a> [private\_subnet\_address\_space](#input\_private\_subnet\_address\_space) | The private subnet address space X.X.X.X - X.X.X.X | `string` | n/a | yes |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | The public key used to encrypt and decrypt messages in network | `string` | n/a | yes |
| <a name="input_public_subnet_address_space"></a> [public\_subnet\_address\_space](#input\_public\_subnet\_address\_space) | The public subnet address space X.X.X.X - X.X.X.X | `string` | n/a | yes |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | The resource group service location | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name | `string` | n/a | yes |
| <a name="input_scale_set_sku_model"></a> [scale\_set\_sku\_model](#input\_scale\_set\_sku\_model) | Model of virtual machine for the scale set instances | `string` | n/a | yes |
| <a name="input_virtual_network_address_space"></a> [virtual\_network\_address\_space](#input\_virtual\_network\_address\_space) | The virtual network address space X.X.X.X - X.X.X.X | `string` | n/a | yes |
| <a name="input_web_app_name"></a> [web\_app\_name](#input\_web\_app\_name) | The web appliction name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_scale_set_password"></a> [scale\_set\_password](#output\_scale\_set\_password) | Create VM password available for output. |
<!-- END_TF_DOCS -->