terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = ">= 0.25.18"
    }
  }
}

resource "snowflake_role" "ROLE" {
  for_each = var.role_names_grants
  name     = each.key
}

resource "snowflake_role_grants" "ROLE-GRANT" {
  for_each  = var.role_names_grants
  role_name = each.key
  roles     = each.value.roles
  users     = each.value.users
  depends_on = [
    snowflake_role.ROLE
  ]
}

output "ROLES_MAP" {
  value = { for i, j in snowflake_role.ROLE : i => j.name }
}

output "grants" {
  value = snowflake_role_grants.ROLE-GRANT
}



