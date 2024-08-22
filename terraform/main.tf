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
  kind                = "Parse"
  offer_type          = "Standard"

  automatic_failover_enabled = true

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  capabilities {
    name = "EnableMongo"
  }

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = "North Europe"
    failover_priority = 1
  }

  geo_location {
    location          = "North Europe"
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "db_sql" {
  name                = "tf-cosmos-sql-${random_integer.ri.result}"
  resource_group_name = azurerm_cosmosdb_account.rg.name
  account_name        = azurerm_cosmosdb_account.db_account.name
  throughput          = 400


}

resource "azurerm_cosmosdb_sql_container" "db_container" {
  name                  = "counter"
  resource_group_name   = azurerm_cosmosdb_account.rg.name
  account_name          = azurerm_cosmosdb_account.db_account.name
  database_name         = azurerm_cosmosdb_sql_database.db_sql.name
  partition_key_paths   = ["/id"]
  partition_key_version = 1
  throughput            = 400
}