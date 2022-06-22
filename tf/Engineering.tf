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


module "DB_practice" {
    
    source = "./database"
    DB_name = "DB_teams"
    DB_grant_roles = {
        "OWNERSHIP" = [module.ROLES.ROLES_MAP["ENGINEERING"]],
        "USAGE" = [module.ROLES.ROLES_MAP["ENGINEERING"], module.ROLES.ROLES_MAP["SALES"]]
    }
    schema_names = ["FACEBOOK", "TWITTER"]
    schema_grants = {
        "FACEBOOK OWNERSHIP"  = {"roles" = [module.ROLES.ROLES_MAP["ENGINEERING"]]},
        "FACEBOOK USAGE"      = {"roles" = [module.ROLES.ROLES_MAP["ENGINEERING"], module.ROLES.ROLES_MAP["SALES"]]},
        "TWITTER OWNERSHIP"   = {"roles" = [module.ROLES.ROLES_MAP["SALES"]]},
        "TWITTER USAGE"       = {"roles" = [module.ROLES.ROLES_MAP["ENGINEERING"], module.ROLES.ROLES_MAP["SALES"]]}
    }
}

output "DB_name_debug" {
    value = module.DB_practice.DB_name
}

output "SCHEMA_name_debug" {
    value = module.DB_practice.SCHEMA_name
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

