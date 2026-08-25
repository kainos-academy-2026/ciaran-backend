variable "resource_group_name" {
  description = "Base name for the Azure resource group."
  type        = string
  default     = "rg-terraform-ciaran"

  validation {
    condition     = can(regex("^[a-zA-Z0-9._()-]{1,90}$", var.resource_group_name))
    error_message = "resource_group_name must be 1-90 characters and use only letters, numbers, dots, underscores, hyphens, or parentheses."
  }
}

variable "location" {
  description = "Azure region where the resource group will be created."
  type        = string
  default     = "uksouth"

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "location must not be empty."
  }
}

variable "environment" {
  description = "Deployment environment for the resource group."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, or prod."
  }
}
