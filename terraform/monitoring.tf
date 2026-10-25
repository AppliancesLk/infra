resource "azurerm_log_analytics_workspace" "prod" {
  name                = "log-appliances-prod"
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = {
    project     = "Appliances.lk"
    environment = var.environment
    managed_by  = "Terraform"
  }
}
