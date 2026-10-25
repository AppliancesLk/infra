output "resource_group_name" {
  description = "Production Azure resource group."
  value       = azurerm_resource_group.prod.name
}

output "acr_login_server" {
  description = "Production Azure Container Registry login server."
  value       = azurerm_container_registry.prod.login_server
}

output "postgres_host" {
  description = "Production PostgreSQL server hostname."
  value       = azurerm_postgresql_flexible_server.prod.fqdn
}

output "container_app_environment_name" {
  description = "Production Container Apps environment."
  value       = azurerm_container_app_environment.prod.name
}
