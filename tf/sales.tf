# #Create a Sales role
# resource "snowflake_role" "SALES" {
#   name    = "SALES"
#   comment = "A role for all in Sales"
# }

# #Grant the sales role to the accountadmin role
# resource "snowflake_role_grants" "SALES-GRANT" {
#   role_name = snowflake_role.SALES.name

#   roles = [
#     "ACCOUNTADMIN"
#   ]
# }

# module "SALES_MEDIUM_WH" {
#   source          = "./warehouse"
#   warehouse_name  = "SALES_MEDIUM_WH"
#   warehouse_size  = "Medium"
#   warehouse_roles = [snowflake_role.SALES.name]
# }

# module "SALES_X_SMALL_WH" {
#   source          = "./warehouse"
#   warehouse_name  = "SALES_XSMALL"
#   warehouse_size  = "X-small"
#   warehouse_role_grants = [snowflake_role.SALES.name]
# }

# #Create a database and grant usage access to it
# module "DB_SALES" {
#   source   = "./database"
#   DB_name  = "DB-SALES"
#   DB_roles = [snowflake_role.SALES.name]
# }

# module "SCHEMA_SALES" {
#   source                = "./schema"
#   schema_name           = "SALES-SCHEMA"
#   schema_databasename   = module.DB_SALES.DB_name
#   warehouse_role_grants = [snowflake_role.SALES.name]
# }

# #Create a Sample Table within the above Schema
# resource "snowflake_table" "EMPLOYEES" {
#   database            = module.DB_SALES.DB_name
#   schema              = snowflake_schema.SALES.name
#   name                = "EMPLOYEES"
#   data_retention_days = snowflake_schema.test_schema.data_retention_days
#   change_tracking     = true

#   column {
#     name     = "ID"
#     type     = "VARCHAR(16777216)"
#     nullable = true
#   }

#   column {
#     name     = "NAME"
#     type     = "VARCHAR(16777216)"
#     nullable = true
#   }

#   column {
#     name     = "CURRENT"
#     type     = "BOOLEAN"
#     nullable = true
#   }

# }

# #Create a Sample View within the above Schema
# resource "snowflake_view" "CURRENT_EMPLOYEEES" {
#   database = module.DB_SALES.DB_name
#   schema   = snowflake_schema.SALES.name
#   name     = "CURRENT_EMPLOYEEES"

#   statement = <<-SQL
#     select * from ${snowflake_table.EMPLOYEES.name} where "CURRENT" = true;
# SQL
# }

# #Granting people in Sales access to the table defined above:
# resource "snowflake_table_grant" "GRANT-TABLE-SALES" {
#   database_name = module.DB_SALES.DB_name
#   schema_name   = snowflake_schema.SALES.name
#   table_name    = snowflake_table.EMPLOYEES.name
#   privilege     = "SELECT"
#   roles         = [snowflake_role.SALES.name]

#   with_grant_option = false
# }

# #Granting people in Sales access to the view defined above:
# resource "snowflake_view_grant" "GRANT-VIEW-SALES" {
#   database_name = module.DB_SALES.DB_name
#   schema_name   = snowflake_schema.SALES.name
#   view_name     = snowflake_view.CURRENT_EMPLOYEEES.name
#   privilege     = "SELECT"
#   roles         = [snowflake_role.SALES.name]

#   with_grant_option = false
# }
