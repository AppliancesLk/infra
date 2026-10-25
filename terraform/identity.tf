resource "azurerm_user_assigned_identity" "backend" {
  name                = "id-appliances-api-prod"
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location

  tags = {
    project     = "Appliances.lk"
    environment = var.environment
    managed_by  = "Terraform"
  }
}

resource "azurerm_user_assigned_identity" "frontend" {
  name                = "id-appliances-web-prod"
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location

  tags = {
    project     = "Appliances.lk"
    environment = var.environment
    managed_by  = "Terraform"
  }
}

resource "azurerm_role_assignment" "backend_acr_pull" {
  scope                            = azurerm_container_registry.prod.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_user_assigned_identity.backend.principal_id
  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "frontend_acr_pull" {
  scope                            = azurerm_container_registry.prod.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_user_assigned_identity.frontend.principal_id
  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}