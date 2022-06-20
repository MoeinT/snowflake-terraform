module "ENGINEERING-ROLE" {
  source    = "./role"
  role_name = "ENGINEERING"
}

module "DB_ENGINEERING" {
  source   = "./database"
  DB_name  = "DB_ENGINEERING"
  DB_roles = [module.ENGINEERING-ROLE.ROLE_NAME]
}

module "WH_ENGINEERING" {
  source          = "./warehouse"
  warehouse_name  = "WH_ENGINEERING"
  warehouse_roles = [module.ENGINEERING-ROLE.ROLE_NAME]
}

module "SCHEMA_ENGINEERING" {
  source                = "./schema"
  schema_name           = "ENGINEERING-SCHEMA"
  schema_databasename   = module.DB_ENGINEERING.DB_name
  schema_snowflake_role = [module.ENGINEERING-ROLE.ROLE_NAME]
}

