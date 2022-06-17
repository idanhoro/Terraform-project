variable "resource_group_name" {
  type        = string
  description = "The resource group name"
}

variable "resource_group_location" {
  type        = string
  description = "The resource group service location"
}

variable "web_app_name" {
  type        = string
  description = "The web appliction name"
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

variable "scale_set_sku_model" {
  type        = string
  description = "Model of virtual machine for the scale set instances"
}

variable "instance_count" {
  type        = number
  description = "Number of instances to create using the scale set"
}

variable "app_public_subnet_nsg_id" {
  type        = string
  description = "The resource's ID of the public subnet network security group"
}

variable "app_public_subnet_id" {
  type        = string
  description = "The resource's ID of the public subnet"
}

variable "lb_pool_id" {
  type        = string
  description = "The resource's ID of the load balancer pool"
}

variable "lbnatpool_id" {
  type        = string
  description = "The resource's ID of the load balancer nat rules pool"
}