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
  name                = "tfex-cosmos-account-${random_integer.ri.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  capacity {
    name = "serverless"
  }
}

resource "azurerm_cosmosdb_sql_database" "example" {
  name                = "tfex-cosmos-sql-${random_integer.ri.result}"
  resource_group_name = data.azurerm_cosmosdb_account.example.resource_group_name
  account_name        = data.azurerm_cosmosdb_account.example.name
  throughput          = 400
}