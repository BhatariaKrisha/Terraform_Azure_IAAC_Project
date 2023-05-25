output public_dns_name {
  value       = data.azurerm_dns_zone.dns_name.name
  description = "description"
  depends_on  = []
}
