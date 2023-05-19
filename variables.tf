variable "azure_region" {
  type        = string
  description = "Region for Azure"
}

variable "rg_name" {
    type        = string
    description = "Resource group for Infrastructure"
}

variable "app_vnet" {
  type        = string
  default     = "app-vnet"
}

variable "hub_vnet" {
  type        = string
  default     = "hub-vnet"
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
  default     = "AzureFirewallSubnet"
}

variable "afw_pip" {
  type        = string
  default     = "afwpip"
}

variable "key_vault_name" {
  type = string
  description = "Key vault name not used before"
}