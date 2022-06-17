variable "resource_group_name" {
  type        = string
  description = "The resource group name"
}

variable "resource_group_location" {
  type        = string
  description = "The resource group service location"
}

variable "virtual_network_address_space" {
  type        = string
  description = "The virtual network address space X.X.X.X - X.X.X.X"
}

variable "public_subnet_address_space" {
  type        = string
  description = "The public subnet address space X.X.X.X - X.X.X.X"
}

variable "private_subnet_address_space" {
  type        = string
  description = "The private subnet address space X.X.X.X - X.X.X.X"
}

variable "web_app_name" {
  type        = string
  description = "The web appliction name"
}

variable "allowed_ip_address" {
  type        = string
  description = "The ip/s are allowed to connect with ssh to the web application servers"
}

variable "public_key" {
  type        = string
  description = "The public key used to encrypt and decrypt messages in network"
}

variable "admin_user" {
  type        = string
  description = "The username of the instances"
}

variable "admin_password" {
  type        = string
  description = "The password of the instances"
}

variable "image_version_name" {
  type        = string
  description = "String represent the image version"
}

variable "image_name" {
  type        = string
  description = "The image's name"
}

variable "image_gallery_name" {
  type        = string
  description = "The images's gallery name"
}

variable "image_resource_group_name" {
  type        = string
  description = "The name of the resource group associated with the image"
}

variable "postgres_username" {
  type        = string
  description = "Username of the postgresql database"
}

variable "postgres_password" {
  type        = string
  description = "Password of the postgresql database"
}

variable "postgres_sku_model" {
  type        = string
  description = "Model of virtual machine for the database"
}

variable "instance_count" {
  type        = number
  description = "Number of instances to create using the scale set"
}

variable "scale_set_sku_model" {
  type        = string
  description = "Model of virtual machine for the scale set instances"
}
