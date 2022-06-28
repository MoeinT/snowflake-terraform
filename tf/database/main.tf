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

resource "snowflake_database_grant" "DB-GRANT" {
  for_each      = var.DB_grant_roles
  database_name = snowflake_database.DATABASE.name
  privilege     = each.key
  roles         = each.value

  with_grant_option = false
}

#SCHEMAS and GRANTS

resource "snowflake_schema" "SCHEMA" {
  for_each            = toset(var.schema_names)
  database            = snowflake_database.DATABASE.name
  name                = each.key
  data_retention_days = var.SCHEMA_data_retention_days
}

resource "snowflake_schema_grant" "SCHEMA-GRANT" {
  for_each          = var.schema_grants
  database_name     = snowflake_database.DATABASE.name
  schema_name       = split(" ", each.key)[0]
  privilege         = join(" ", slice(split(" ", each.key), 1, length(split(" ", each.key))))
  roles             = each.value.roles
  with_grant_option = var.SCHEMA_with_grant_option
  depends_on = [
    snowflake_schema.SCHEMA
  ]
}

output "DB_name" {
  value = snowflake_database.DATABASE.name
}

output "SCHEMA_name" {
  value = {for i, j in snowflake_schema.SCHEMA: i => j.name}
}