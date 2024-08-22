# Providers

## Backend storage account 
variable "resource_group_name" {
  description = "The Azure Resource Group"
  type        = string
}

variable "key" {
  description = "The access key for the Azure Storage Account"
  type        = string
  sensitive   = true
}


## Service principal variables
variable "client_id" {
  description = "The Service principal client ID"
  type        = string
}

variable "client_secret" {
  description = "The Service principal client secret"
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "The Azure Entra ID tenant ID"
  type        = string
}


# Main
variable "resource_group_location" {
  type        = string
  default     = "North Europe"
  description = "Location of the resource group."
}