resource "azurerm_storage_account" "prod" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.prod.name
  location                 = azurerm_resource_group.prod.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true
  shared_access_key_enabled       = true

  tags = {
    project     = "Appliances.lk"
    environment = var.environment
    managed_by  = "Terraform"
  }
}

resource "azurerm_storage_container" "product_images" {
  name                  = "product-images"
  storage_account_id    = azurerm_storage_account.prod.id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "backend_blob_access" {
  scope                            = azurerm_storage_account.prod.id
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = azurerm_user_assigned_identity.backend.principal_id
  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}