resource "azurerm_container_app" "frontend" {
  name                         = "appliances-web-prod"
  container_app_environment_id = azurerm_container_app_environment.prod.id
  resource_group_name          = azurerm_resource_group.prod.name
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.frontend.id
    ]
  }

  registry {
    server   = azurerm_container_registry.prod.login_server
    identity = azurerm_user_assigned_identity.frontend.id
  }

  template {
    min_replicas                = 1
    max_replicas                = 2
    cooldown_period_in_seconds  = 300
    polling_interval_in_seconds = 30

    container {
      name   = "frontend"
      image  = "${azurerm_container_registry.prod.login_server}/frontend-app:v1.0.0"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "BACKEND_HOST"
        value = local.backend_host
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
    target_port                = 80
    transport                  = "http"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  depends_on = [
    azurerm_role_assignment.frontend_acr_pull,
    azurerm_container_app.backend
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