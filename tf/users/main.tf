terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = ">= 0.25.18"
    }
  }
}

resource "snowflake_user" "USERS" {
  for_each             = var.all_users
  name                 = each.value.first_name
  login_name           = each.value.login_name
  display_name         = "${each.value.first_name} ${each.value.last_name}"
  email                = each.value.email
  first_name           = each.value.first_name
  last_name            = each.value.last_name
  password             = lookup(each.value, "password", "p}Em9U!(3+!F2JET")
  default_warehouse    = lookup(each.value, "default_warehouse", "COMPUTE_WH")
  default_role         = lookup(each.value, "default_role", "PUBLIC")
  must_change_password = lookup(each.value, "must_change_password", false)
}

output "USER_NAMES" {
  value = { for i, j in snowflake_user.USERS : i => j.name }
}