variable "azure_region" {
  type        = string
  description = "Region for Azure"
}

variable "rg_name" {
    type        = string
    description = "Resource group for Infrastructure"
}

variable "dns_zone" {
    type = string
    description = "Dns Zone provided"
}

variable "app_vnet" {
  type        = string
  description = "virtual network name for VM and Gateway"
}

variable "hub_vnet" {
  type        = string
  description = "virtual network name for firewall and key vault"
}

variable "vm_username" {
  type = string
  description = "VM username"
  sensitive = true
}

variable "vm_password" {
  type = string
  description = "VM password"
  sensitive = true
}

variable "afw_subnet" {
  type        = string
  description = "subnet name for azure firewall"
}

variable "afw_pip" {
  type        = string
}

variable "key_vault_name" {
  type = string
  description = "Key vault name not used before"
}