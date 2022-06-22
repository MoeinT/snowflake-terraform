terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = ">= 0.25.18"
    }
  }
}

resource "snowflake_database" "DATABASE" {
  name                        = var.DB_name
  data_retention_time_in_days = var.DB_data_retention_time_in_days
}

resource "snowflake_database_grant" "DATABASE-GRANT" {
  for_each          = var.DB_grant_roles
  database_name     = snowflake_database.DATABASE.name
  privilege         = each.key
  roles             = each.value
  with_grant_option = var.DB_with_grant_option
}

output "DB_name" {
  value = snowflake_database.DATABASE.name
}

####schema
resource "snowflake_schema" "SCHEMA" {
  for_each            = toset(var.schemas)
  database            = snowflake_database.DATABASE.name
  name                = each.key
  data_retention_days = var.schema_data_retention_days
}

resource "snowflake_schema_grant" "GRANT-SCHEMA" {
  for_each          = var.schema_grants
  database_name     = snowflake_database.DATABASE.name
  schema_name       = split(" ", each.key)[0]
  privilege         = join(" ", slice(split(" ", each.key), 1, length(split(" ", each.key))))
  roles             = each.value.roles
  with_grant_option = var.schema_with_grant_option
  depends_on = [
    snowflake_schema.SCHEMA
  ]
}

output "SCHEMA_NAMES" {
  #value = { for i, j in snowflake_schema.SCHEMA : i => j.name }
  value = snowflake_schema.SCHEMA
}

