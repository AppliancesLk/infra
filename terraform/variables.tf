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

variable "storage_account_name" {
  description = "Globally unique Azure Storage Account name used for production product images."
  type        = string
}

variable "jwt_secret" {
  description = "JWT signing secret used by the production API."
  type        = string
  sensitive   = true
}

variable "email_user" {
  description = "Production transactional email account."
  type        = string
  sensitive   = true
}

variable "email_app_password" {
  description = "Application password used for production transactional email."
  type        = string
  sensitive   = true
}

variable "email_from_address" {
  description = "From address used for production transactional email."
  type        = string
}

variable "gemini_api_key" {
  description = "Gemini API key used by the product assistant."
  type        = string
  sensitive   = true
}

variable "payhere_merchant_id" {
  description = "PayHere merchant identifier."
  type        = string
  sensitive   = true
}

variable "payhere_merchant_secret" {
  description = "PayHere merchant secret."
  type        = string
  sensitive   = true
}

variable "payhere_mode" {
  description = "PayHere mode used by the production application."
  type        = string
  default     = "sandbox"

  validation {
    condition     = contains(["sandbox", "live"], var.payhere_mode)
    error_message = "payhere_mode must be either sandbox or live."
  }
}