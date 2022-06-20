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
  database_name     = snowflake_database.DATABASE.name
  privilege         = var.DB_privilege
  roles             = var.DB_roles
  with_grant_option = var.DB_with_grant_option
}

output "DB_name" {
  value = snowflake_database.DATABASE.name
}