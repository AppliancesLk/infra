resource "azurerm_container_app_environment" "prod" {
  name                       = "cae-appliances-prod"
  resource_group_name        = azurerm_resource_group.prod.name
  location                   = azurerm_resource_group.prod.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.prod.id

  tags = {
    project     = "Appliances.lk"
    environment = var.environment
    managed_by  = "Terraform"
  }
}
