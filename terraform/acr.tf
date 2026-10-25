resource "azurerm_container_registry" "prod" {
  name                = "applianceslkprodacr"
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location

  sku           = "Basic"
  admin_enabled = true

  tags = {
    project     = "Appliances.lk"
    environment = var.environment
    managed_by  = "Terraform"
  }
}
