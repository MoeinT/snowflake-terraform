resource "snowflake_role" "ENGINEERING" {
  name = "ENGINEERING"
}

resource "snowflake_role_grants" "ENGINEERING-GRANT" {
  role_name = snowflake_role.ENGINEERING.name

  roles = [
    "ACCOUNTADMIN"
  ]
}

module "DB_ENGINEERING" {
  source   = "./database"
  DB_name  = "DB_ENGINEERING"
  DB_roles = [snowflake_role.ENGINEERING.name]
}

module "WH_ENGINEERING" {
  source          = "./warehouse"
  warehouse_name  = "WH_ENGINEERING"
  warehouse_roles = [snowflake_role.ENGINEERING.name]
}


module "SCHEMA_ENGINEERING" {
  source                = "./schema"
  schema_name           = "ENGINEERING-SCHEMA"
  schema_databasename   = module.DB_ENGINEERING.DB_name
  schema_snowflake_role = [snowflake_role.ENGINEERING.name]
}

