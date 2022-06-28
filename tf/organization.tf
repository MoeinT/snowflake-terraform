#Creating roles and importing one from an existing infrastructure 
#Create roles within your organization
module "ROLES" {
  source    = "./role"
  role_name = ["SALES", "ENGINEERING", "HUMANRESOURCES"]
}

output "debug_role" {
  value = module.ROLES.ROLES_MAP
}

##################################################
#Warehouses
module "COMPUTE_WH_IMPORT" {
  source         = "./warehouse"
  warehouse_name = "COMPUTE_WH"
  warehouse_grant_roles = {
    "OWNERSHIP" = ["ACCOUNTADMIN"]
    "USAGE"     = ["PUBLIC"]
  }
}

module "WH_ROLES" {
  source         = "./warehouse"
  warehouse_name = "WH_SALES_ENG"
  warehouse_grant_roles = {
    "OWNERSHIP" = [module.ROLES.ROLES_MAP["ENGINEERING"]],
    "USAGE"     = [module.ROLES.ROLES_MAP["SALES"], module.ROLES.ROLES_MAP["ENGINEERING"]]
  }
}

##################################################
#Databases
module "DB_HR" {

  source  = "./database"
  DB_name = "DB_HR"
  DB_grant_roles = {
    "OWNERSHIP" = [module.ROLES.ROLES_MAP["HUMANRESOURCES"]],
    "USAGE"     = [module.ROLES.ROLES_MAP["ENGINEERING"], module.ROLES.ROLES_MAP["SALES"], module.ROLES.ROLES_MAP["HUMANRESOURCES"]]
  }
  schema_names = ["PARTNERS", "EMPLOYEES"]
  schema_grants = {
    "EMPLOYEES OWNERSHIP" = { "roles" = [module.ROLES.ROLES_MAP["HUMANRESOURCES"]] },
    "EMPLOYEES USAGE"     = { "roles" = [module.ROLES.ROLES_MAP["ENGINEERING"], module.ROLES.ROLES_MAP["SALES"], module.ROLES.ROLES_MAP["HUMANRESOURCES"]] },
    "PARTNERS OWNERSHIP"   = { "roles" = [module.ROLES.ROLES_MAP["HUMANRESOURCES"]] },
    "PARTNERS USAGE"       = { "roles" = [module.ROLES.ROLES_MAP["ENGINEERING"], module.ROLES.ROLES_MAP["SALES"], module.ROLES.ROLES_MAP["HUMANRESOURCES"]] }
  }
}

module "DB_SCHEMA" {

  source  = "./database"
  DB_name = "DB_teams"
  DB_grant_roles = {
    "OWNERSHIP" = [module.ROLES.ROLES_MAP["ENGINEERING"]],
    "USAGE"     = [module.ROLES.ROLES_MAP["ENGINEERING"], module.ROLES.ROLES_MAP["SALES"]]
  }
  schema_names = ["FACEBOOK", "TWITTER"]
  schema_grants = {
    "FACEBOOK OWNERSHIP" = { "roles" = [module.ROLES.ROLES_MAP["ENGINEERING"]] },
    "FACEBOOK USAGE"     = { "roles" = [module.ROLES.ROLES_MAP["ENGINEERING"], module.ROLES.ROLES_MAP["SALES"]] },
    "TWITTER OWNERSHIP"  = { "roles" = [module.ROLES.ROLES_MAP["SALES"]] },
    "TWITTER USAGE"      = { "roles" = [module.ROLES.ROLES_MAP["ENGINEERING"], module.ROLES.ROLES_MAP["SALES"]] }
  }
}

output "DB_debug" {
  value = module.DB_SCHEMA.DB_name
}

output "SCHEMA_name_debug" {
  value = module.DB_SCHEMA.SCHEMA_name
}
##################################################
#Users
module "ALL_USERS" {

  source = "./users"
  all_users = {
    "Amin" : {
      "login_name"   = "Amin", "first_name" = "Amin", "last_name" = "Torabi", "email" = "amin.torabi@gmail.com",
      "default_role" = "ACCOUNTADMIN", "must_change_password" = true
    },

    "Atiyeh" : {
      "login_name"        = "Atiyeh", "first_name" = "Atiyeh", "last_name" = "Torabi", "email" = "atiyeh.torabi@gmail.com",
      "default_warehouse" = module.COMPUTE_WH_IMPORT.WH_name
    },

    "Moein" : {
      "login_name"   = "Moein", "first_name" = "Moein", "last_name" = "Torabi", "email" = "moin.torabi@gmail.com",
      "default_role" = "ACCOUNTADMIN", "password" = var.snowflake_password
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
