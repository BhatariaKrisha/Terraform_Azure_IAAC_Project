variable "azure_region" {
  type        = string
  default     = "West Europe"
  description = "Region for Azure"
}

variable "rg_name" {
    type        = string
    default     = "rg-krisha-playground"
}

variable "app_vnet" {
  type        = string
  default     = "app-vnet"
}

variable "hub_vnet" {
  type        = string
  default     = "hub-vnet"
}

variable "afw_subnet" {
  type        = string
  default     = "AzureFirewallSubnet"
}

variable "afw_pip" {
  type        = string
  default     = "afwpip"
}