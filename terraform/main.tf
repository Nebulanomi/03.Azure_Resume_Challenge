# Create the RG with its unique ID
resource "azurerm_resource_group" "rg" {
  name     = "rg-resume"
  location = var.resource_group_location
  tags = {
    "Budget"              = "100€",
    "Data classification" = "Private",
    "End date"            = "Never",
    "Owner"               = "Alexandre Pereira",
    "Secondary owner"     = "None",
    "Team name"           = "None",
  }
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "db_account" {
  name                = "tf-cosmos-account-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  kind                      = "GlobalDocumentDB"
  offer_type                = "Standard"
  consistency_policy        = "Session"
  enable_automatic_failover = true

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }

  capabilities {
    name = "EnableServerless"
  }
}

resource "azurerm_cosmosdb_sql_database" "db_sql" {
  name                = "resume"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.db_account.name
}

resource "azurerm_cosmosdb_sql_container" "db_container" {
  name                  = "counter"
  resource_group_name   = azurerm_resource_group.rg.name
  account_name          = azurerm_cosmosdb_account.db_account.name
  database_name         = azurerm_cosmosdb_sql_database.db_sql.name
  partition_key_paths   = ["/id"]
  partition_key_version = 1

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }

  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }
}