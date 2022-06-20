terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = ">= 0.25.18"
    }
  }
}

resource "snowflake_role" "ROLE" {
  name = var.role_name
}

resource "snowflake_role_grants" "ROLE-GRANT" {
  role_name = snowflake_role.ROLE.name
  roles = var.role_grant_to
}

output "ROLE_NAME" {
  value = snowflake_role.ROLE.name
}


