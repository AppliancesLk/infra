resource "azurerm_resource_group" "prod" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    project     = "Appliances.lk"
    environment = var.environment
    managed_by  = "Terraform"
  }
}
