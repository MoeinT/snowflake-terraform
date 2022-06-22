terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = ">= 0.25.18"
    }
  }
}

resource "snowflake_role" "ROLE" {
  for_each = toset(var.role_name)
  name     = each.key
}

resource "snowflake_role_grants" "ROLE-GRANT" {
  for_each  = { for i, j in snowflake_role.ROLE : i => j.name }
  role_name = each.value
  roles     = var.role_grant_to
}

output "ROLES_MAP" {
  value = { for i, j in snowflake_role.ROLE : i => j.name }
}



