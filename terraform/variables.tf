variable "location" {
  description = "Azure region used for the production environment."
  type        = string
  default     = "Central India"
}

variable "resource_group_name" {
  description = "Name of the production resource group."
  type        = string
  default     = "rg-appliances-prod"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "production"
}

variable "postgres_admin_username" {
  description = "PostgreSQL administrator username."
  type        = string
  sensitive   = true
}

variable "postgres_admin_password" {
  description = "PostgreSQL administrator password."
  type        = string
  sensitive   = true
}
