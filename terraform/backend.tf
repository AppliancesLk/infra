locals {
  backend_host = "appliances-api-prod.${azurerm_container_app_environment.prod.default_domain}"
  backend_url  = "https://${local.backend_host}"

  frontend_host = "appliances-web-prod.${azurerm_container_app_environment.prod.default_domain}"
  frontend_url  = "https://${local.frontend_host}"
}

resource "azurerm_container_app" "backend" {
  name                         = "appliances-api-prod"
  container_app_environment_id = azurerm_container_app_environment.prod.id
  resource_group_name          = azurerm_resource_group.prod.name
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.backend.id
    ]
  }

  registry {
    server   = azurerm_container_registry.prod.login_server
    identity = azurerm_user_assigned_identity.backend.id
  }

  secret {
    name  = "db-password"
    value = var.postgres_admin_password
  }

  secret {
    name  = "jwt-secret"
    value = var.jwt_secret
  }

  secret {
    name  = "email-app-password"
    value = var.email_app_password
  }

  secret {
    name  = "gemini-api-key"
    value = var.gemini_api_key
  }

  secret {
    name  = "payhere-merchant-secret"
    value = var.payhere_merchant_secret
  }

  template {
    min_replicas                = 1
    max_replicas                = 2
    cooldown_period_in_seconds  = 300
    polling_interval_in_seconds = 30

    container {
      name   = "backend"
      image  = "${azurerm_container_registry.prod.login_server}/backend-app:v1.0.0"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "NODE_ENV"
        value = "production"
      }

      env {
        name  = "PORT"
        value = "3000"
      }

      env {
        name  = "DB_HOST"
        value = azurerm_postgresql_flexible_server.prod.fqdn
      }

      env {
        name  = "DB_PORT"
        value = "5432"
      }

      env {
        name  = "DB_USERNAME"
        value = var.postgres_admin_username
      }

      env {
        name        = "DB_PASSWORD"
        secret_name = "db-password"
      }

      env {
        name  = "DB_NAME"
        value = azurerm_postgresql_flexible_server_database.app.name
      }

      env {
        name  = "DB_SSL"
        value = "true"
      }

      env {
        name        = "JWT_SECRET"
        secret_name = "jwt-secret"
      }

      env {
        name  = "JWT_EXPIRES_IN"
        value = "1d"
      }

      env {
        name  = "FRONTEND_URL"
        value = local.frontend_url
      }

      env {
        name  = "SESSION_TTL_SECONDS"
        value = "86400"
      }

      env {
        name  = "EMAIL_PROVIDER"
        value = "gmail"
      }

      env {
        name  = "EMAIL_USER"
        value = var.email_user
      }

      env {
        name        = "EMAIL_APP_PASSWORD"
        secret_name = "email-app-password"
      }

      env {
        name  = "EMAIL_FROM_NAME"
        value = "Appliances.lk"
      }

      env {
        name  = "EMAIL_FROM_ADDRESS"
        value = var.email_from_address
      }

      env {
        name  = "EMAIL_ASSET_BASE_URL"
        value = local.backend_url
      }

      env {
        name        = "GEMINI_API_KEY"
        secret_name = "gemini-api-key"
      }

      env {
        name  = "GEMINI_MODEL"
        value = "gemini-3.5-flash-lite"
      }

      env {
        name  = "PAYHERE_MERCHANT_ID"
        value = var.payhere_merchant_id
      }

      env {
        name        = "PAYHERE_MERCHANT_SECRET"
        secret_name = "payhere-merchant-secret"
      }

      env {
        name  = "PAYHERE_MODE"
        value = var.payhere_mode
      }

      env {
        name  = "STORAGE_MODE"
        value = "cloud"
      }

      env {
        name  = "STORAGE_ACCOUNT_URL"
        value = azurerm_storage_account.prod.primary_blob_endpoint
      }

      env {
        name  = "PRODUCT_IMAGE_CONTAINER"
        value = azurerm_storage_container.product_images.name
      }

      env {
        name  = "PRODUCT_IMAGE_MAX_BYTES"
        value = "5242880"
      }

      env {
        name  = "AZURE_CLIENT_ID"
        value = azurerm_user_assigned_identity.backend.client_id
      }
    }

    http_scale_rule {
      name                = "http-scaler"
      concurrent_requests = "10"
    }
  }

  ingress {
    external_enabled           = true
    allow_insecure_connections = false
    target_port                = 3000
    transport                  = "http"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  depends_on = [
    azurerm_role_assignment.backend_acr_pull,
    azurerm_role_assignment.backend_blob_access
  ]

  lifecycle {
    ignore_changes = [
      ingress[0].traffic_weight,
      template[0].cooldown_period_in_seconds,
      template[0].polling_interval_in_seconds
    ]
  }

  tags = {
    project     = "Appliances.lk"
    environment = var.environment
    managed_by  = "Terraform"
  }
}