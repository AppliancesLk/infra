resource "azurerm_container_app_environment" "prod" {
  name                       = "cae-appliances-prod"
  resource_group_name        = azurerm_resource_group.prod.name
  location                   = azurerm_resource_group.prod.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.prod.id

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
    minimum_count         = 0
    maximum_count         = 0
  }

  tags = {
    project     = "Appliances.lk"
    environment = var.environment
    managed_by  = "Terraform"
  }
}