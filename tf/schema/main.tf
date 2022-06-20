terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = ">= 0.25.18"
    }
  }
}

resource "snowflake_schema" "SCHEMA" {
  database            = var.schema_databasename
  name                = var.schema_name
  data_retention_days = var.schema_data_retention_days
}

resource "snowflake_schema_grant" "GRANT-SCHEMA" {
  database_name     = var.schema_databasename
  schema_name       = snowflake_schema.SCHEMA.name
  privilege         = var.schema_privilege
  roles             = var.schema_snowflake_role
  with_grant_option = var.schema_with_grant_option
}

output "schema_name" {
  value = snowflake_schema.SCHEMA.name
}