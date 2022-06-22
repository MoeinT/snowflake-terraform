#Create roles within your organization
module "ROLES" {
  source    = "./role"
  role_name = ["SALES", "ENGINEERING"]
}

output "debug_role" {
  value = module.ROLES.ROLES_MAP
}

module "WH_ROLES" {
  source         = "./warehouse"
  warehouse_name = "WH_SALES_ENG"
  warehouse_grant_roles = {
    "OWNERSHIP" = [module.ROLES.ROLES_MAP["ENGINEERING"]],
    "USAGE"     = [module.ROLES.ROLES_MAP["SALES"], module.ROLES.ROLES_MAP["ENGINEERING"]]
  }
}

module "DB_SCHEMA" {
  source  = "./database"
  DB_name = "DB_SALES_ENG"

  DB_grant_roles = {
    "OWNERSHIP" = [module.ROLES.ROLES_MAP["ENGINEERING"]],
    "USAGE"     = [module.ROLES.ROLES_MAP["SALES"], module.ROLES.ROLES_MAP["ENGINEERING"]]
  }

  schemas = ["ENGINEERING_SCHEMA", "SALES_SCHEMA"]

  schema_grants = {
    "ENGINEERING_SCHEMA OWNERSHIP" = {"roles" = [module.ROLES.ROLES_MAP["ENGINEERING"]] },
    "ENGINEERING_SCHEMA USAGE"     = {"roles" = [module.ROLES.ROLES_MAP["ENGINEERING"], module.ROLES.ROLES_MAP["SALES"]] },
    "SALES_SCHEMA OWNERSHIP"       = {"roles" = [module.ROLES.ROLES_MAP["SALES"]] },
    "SALES_SCHEMA USAGE"           = {"roles" = [module.ROLES.ROLES_MAP["ENGINEERING"], module.ROLES.ROLES_MAP["SALES"]] }
  }
}

output "SCHEMA_DEBUG" {
  value = module.DB_SCHEMA.SCHEMA_NAMES
}

output "DB_DEBUG" {
  value = module.DB_SCHEMA.DB_name
}

module "ALL_USERS" {

  source = "./users"
  all_users = {
    "Amin" : {
      "first_name"   = "Amin", "last_name" = "Torabi", "email" = "amin.torabi@gmail.com",
      "default_role" = "ACCOUNTADMIN", "must_change_password" = true
    },

    "Atiyeh" : {
      "first_name" = "Atiyeh", "last_name" = "Torabi", "email" = "atiyeh.torabi@gmail.com", "default_warehouse" = "COMPUTE_WH"
    }
  }
}

output "debug_user" {
  value = module.ALL_USERS.USER_NAMES
}

resource "snowflake_role_grants" "ROLE_GRANTS" {
  for_each = {
    (module.ROLES.ROLES_MAP["ENGINEERING"]) = module.ALL_USERS.USER_NAMES["Amin"],
  (module.ROLES.ROLES_MAP["SALES"]) = module.ALL_USERS.USER_NAMES["Atiyeh"] }
  role_name = each.key

  roles = [
    "ACCOUNTADMIN"
  ]

  users = [
    each.value
  ]
}

