# Create Reosurce group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}
# Create Virtual network
resource "azurerm_virtual_network" "app_virtual_network" {
  name                = "${var.web_app_name}-vnet"
  address_space       = [var.virtual_network_address_space]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
# Create public subnet associated to the network
resource "azurerm_subnet" "app_public_subnet" {
  name                 = "${var.web_app_name}-private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.app_virtual_network.name
  address_prefixes     = [var.public_subnet_address_space]
}

# Create private subnet associated to the network
resource "azurerm_subnet" "app_private_subnet" {
  name                 = "${var.web_app_name}-public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.app_virtual_network.name
  address_prefixes     = [var.private_subnet_address_space]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# Create net-work security group for the public subnet

resource "azurerm_network_security_group" "nsg_public_subnet" {
  name                = "${var.web_app_name}-nsg-public-subnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "port_ssh"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.allowed_ip_address
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "port_8080"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "DENY_ALL"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}
# Create net-work security group for the private subnet

resource "azurerm_network_security_group" "nsg_private_subnet" {
  name                = "${var.web_app_name}-nsg-private-network"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "port_ssh"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "*"
    source_address_prefix      = var.public_subnet_address_space
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "port_5432"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "5432"
    destination_port_range     = "*"
    source_address_prefix      = var.public_subnet_address_space
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "DENY_ALL"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create associations for the network security groups with the subnets.

resource "azurerm_subnet_network_security_group_association" "public_nsg_association" {
  subnet_id                 = azurerm_subnet.app_public_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_public_subnet.id
}
resource "azurerm_subnet_network_security_group_association" "private_nsg_association" {
  subnet_id                 = azurerm_subnet.app_private_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_private_subnet.id
}

# Create static public ip to use the DNS

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.web_app_name}-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = azurerm_resource_group.rg.name
}

# Create load balancer associated to pool

resource "azurerm_lb" "webapp_load_balancer" {
  name                = "${var.web_app_name}-load-balancer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "pool" {
  loadbalancer_id = azurerm_lb.webapp_load_balancer.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = azurerm_resource_group.rg.name
  name                           = "NatRules"
  loadbalancer_id                = azurerm_lb.webapp_load_balancer.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50010
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}
resource "azurerm_lb_rule" "lb_port_8080_rule" {
  loadbalancer_id                = azurerm_lb.webapp_load_balancer.id
  name                           = "lb_rule_8080"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.pool.id]
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "loadbalancer_probe" {
  //resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id = azurerm_lb.webapp_load_balancer.id
  name            = "http-probe"
  protocol        = "Http"
  request_path    = "/health"
  port            = 8080
}

# Creating a key for the group
resource "azurerm_ssh_public_key" "public-key" {
  name                = "${var.web_app_name}-key"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  public_key          = var.public_key
}

# Creating virtual network scale set
module "app_scale_set" {
  source                    = "../modules/scale_set_module"
  web_app_name              = var.web_app_name
  admin_user                = var.admin_user
  admin_password            = var.admin_password
  resource_group_location   = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  app_public_subnet_nsg_id  = azurerm_network_security_group.nsg_public_subnet.id
  app_public_subnet_id      = azurerm_subnet.app_public_subnet.id
  lb_pool_id                = azurerm_lb_backend_address_pool.pool.id
  lbnatpool_id              = azurerm_lb_nat_pool.lbnatpool.id
  image_version_name        = var.image_version_name
  image_name                = var.image_name
  image_gallery_name        = var.image_gallery_name
  image_resource_group_name = var.image_resource_group_name
  instance_count            = var.instance_count
  scale_set_sku_model       = var.scale_set_sku_model
}

# Create DNS ZONE
resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "${azurerm_resource_group.rg.name}-database55.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}
# Link the private dns zone to the virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_vnl" {
  name                  = "${azurerm_resource_group.rg.name}.dns-link"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.app_virtual_network.id
  resource_group_name   = azurerm_resource_group.rg.name
}

# Create manged postgres database server.
resource "azurerm_postgresql_flexible_server" "postgres_database_server" {
  name                   = "${azurerm_resource_group.rg.name}-database"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "12"
  delegated_subnet_id    = azurerm_subnet.app_private_subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.private_dns_zone.id
  administrator_login    = var.postgres_username
  administrator_password = var.postgres_password
  zone                   = "1"

  storage_mb = 32768

  sku_name   = var.postgres_sku_model
  depends_on = [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_vnl]

}

# Disabling SSL
resource "azurerm_postgresql_flexible_server_configuration" "db-config-no-ssl" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.postgres_database_server.id
  value     = "off"
}

# Create VM password available for output.
output "scale_set_password" {
  sensitive = true
  value     = module.app_scale_set.scale_set_password_output
}

# Lock the terraform state and store it in blob storage
terraform {
  backend "azurerm" {
    resource_group_name  = "blob-storage"
    storage_account_name = "idanho55"
    container_name       = "wieght-tracker-container"
    key                  = "terraform.tfstate"
  }
}

resource "azurerm_storage_blob" "blob_storage_name" {
  name                   = "terraform_state"
  storage_account_name   = "idanho55"
  storage_container_name = "wieght-tracker-container"
  type                   = "Block"
  source                 = ".terraform/terraform.tfstate"
}