#Create a Sales role
resource "snowflake_role" "SALES" {
  name    = "SALES"
  comment = "A role for all in Sales"
}

#Grant the sales role to the accountadmin role
resource "snowflake_role_grants" "SALES-GRANT" {
  role_name = snowflake_role.SALES.name

  roles = [
    "ACCOUNTADMIN"
  ]
}

#Create a new sales warehouse called SALES_XSMALL
resource "snowflake_warehouse" "SALES_XSMALL" {
  name                = "SALES_XSMALL"
  comment             = "A XS-WH for all in Sales"
  warehouse_size      = "X-small"
  auto_resume         = true
  auto_suspend        = 60
  max_cluster_count   = 3
  min_cluster_count   = 1
  scaling_policy      = "ECONOMY"
  initially_suspended = true
}

#Grant usage of it to the sales role
resource "snowflake_warehouse_grant" "GRANT-WH-SALES" {
  warehouse_name = snowflake_warehouse.SALES_XSMALL.name
  privilege      = "USAGE"

  roles = [
    snowflake_role.SALES.name
  ]

  with_grant_option = false
}

#Create a DB for SALES
resource "snowflake_database" "DB-SALES" {
  name    = "DB-SALES"
  comment = "DB for all in Sales"
}

#Grating people in SALES access to the above DB
resource "snowflake_database_grant" "GRANT-DB-SALES" {
  database_name = snowflake_database.DB-SALES.name

  privilege         = "USAGE"
  roles             = [snowflake_role.SALES.name]
  with_grant_option = false
}

#Create a Schema within the above DB
resource "snowflake_schema" "SALES" {
  database            = snowflake_database.DB-SALES.name
  name                = "SALES-SCHEMA"
  data_retention_days = 1
}

#Create a Sample Table within the above Schema
resource "snowflake_table" "EMPLOYEES" {
  database            = snowflake_database.DB-SALES.name
  schema              = snowflake_schema.SALES.name
  name                = "EMPLOYEES"
  data_retention_days = snowflake_schema.test_schema.data_retention_days
  change_tracking     = true

  column {
    name     = "ID"
    type     = "VARCHAR(16777216)"
    nullable = true
  }

  column {
    name     = "NAME"
    type     = "VARCHAR(16777216)"
    nullable = true
  }

  column {
    name     = "CURRENT"
    type     = "BOOLEAN"
    nullable = true
  }

}

#Create a Sample View within the above Schema
resource "snowflake_view" "CURRENT_EMPLOYEEES" {
  database = snowflake_database.DB-SALES.name
  schema   = snowflake_schema.SALES.name
  name     = "CURRENT_EMPLOYEEES"

  statement = <<-SQL
    select * from ${snowflake_table.EMPLOYEES.name} where "CURRENT" = true;
SQL
}


#Granting people in Sales access to the schema defined above
resource "snowflake_schema_grant" "GRANT-SCHEMA-SALES" {
  database_name = snowflake_database.DB-SALES.name
  schema_name   = snowflake_schema.SALES.name

  privilege = "USAGE"
  roles     = [snowflake_role.SALES.name]

  with_grant_option = false
}

#Granting people in Sales access to the table defined above:
resource "snowflake_table_grant" "GRANT-TABLE-SALES" {
  database_name = snowflake_database.DB-SALES.name
  schema_name   = snowflake_schema.SALES.name
  table_name    = snowflake_table.EMPLOYEES.name
  privilege     = "SELECT"
  roles         = [snowflake_role.SALES.name]

  with_grant_option = false
}

#Granting people in Sales access to the view defined above:
resource "snowflake_view_grant" "GRANT-VIEW-SALES" {
  database_name = snowflake_database.DB-SALES.name
  schema_name   = snowflake_schema.SALES.name
  view_name     = snowflake_view.CURRENT_EMPLOYEEES.name
  privilege     = "SELECT"
  roles         = [snowflake_role.SALES.name]

  with_grant_option = false
}
