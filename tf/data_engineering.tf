#Create a database in Snowflake 
resource "snowflake_database" "DB-DATAENGINEERS" {
  name    = "DB-DATAENGINEERS"
  comment = "My firs db with Terraform"
}

#Creating a small warehouse for data engineering
resource "snowflake_warehouse" "Data_Engineers_WH" {
  name                = "DATA_ENGINEERS_WH_XS"
  comment             = "Creating a Small WH for DEs"
  warehouse_size      = "X-small"
  auto_resume         = true
  auto_suspend        = 60
  max_cluster_count   = 3
  min_cluster_count   = 1
  scaling_policy      = "ECONOMY"
  initially_suspended = true
}

# Create a user object for Amin
resource "snowflake_user" "Amin" {
  name         = "Amin"
  login_name   = "Amin"
  comment      = "Enjoy your Snowflake experience :-)"
  password     = "p}Em9U!(3+!F2JET"
  disabled     = false
  display_name = "Amin"
  email        = "amin.torabi@gmail.com"
  first_name   = "Amin"
  last_name    = "Torabi"

  default_warehouse    = snowflake_warehouse.Data_Engineers_WH.name
  default_role         = "ACCOUNTADMIN"
  must_change_password = true
}


#Creating a role: 
resource "snowflake_role" "Data-Engineering" {
  name    = "DATAENGINEERING"
  comment = "A role for all Data Engineers"
}

#Assignin a usage of a role to a user 
#We can optionally provide a list of roles that the role_name wil be granted to
resource "snowflake_role_grants" "DATAENGINEERING_GRANTS" {
  role_name = snowflake_role.Data-Engineering.name

  roles = [
    "ACCOUNTADMIN"
  ]

  users = [
    "${snowflake_user.Amin.name}"
  ]
}

#Grant warehouses to all Data Engineers 
resource "snowflake_warehouse_grant" "GRANT-WH-SMALL-DATA-ENIGINEERS" {
  warehouse_name = snowflake_warehouse.Data_Engineers_WH.name
  privilege      = "USAGE"

  roles = [
    snowflake_role.Data-Engineering.name
  ]

  with_grant_option = false
}

#Granting DEs access to a our DB
resource "snowflake_database_grant" "GRANT-DB-DATA-ENGINEERS" {
  database_name = snowflake_database.DB-DATAENGINEERS.name

  privilege         = "USAGE"
  roles             = [snowflake_role.Data-Engineering.name]
  with_grant_option = false
}

#Create a schema within a database
resource "snowflake_schema" "test_schema" {
  database = snowflake_database.DB-DATAENGINEERS.name
  name     = "TEST_SCHEMA_TERRAFORM"
  comment  = "A schema created by Terraform."

  is_transient        = false
  is_managed          = false
  data_retention_days = 1
}

#Create a table within that Schema
resource "snowflake_table" "cases_death" {
  database            = snowflake_database.DB-DATAENGINEERS.name
  schema              = snowflake_schema.test_schema.name
  name                = "TEST_CASES_DEATHS"
  comment             = "Replicating the cases and deaths table"
  data_retention_days = snowflake_schema.test_schema.data_retention_days
  change_tracking     = true

  column {
    name     = "country"
    type     = "VARCHAR(16777216)"
    nullable = false
  }

  column {
    name     = "country_code_2_digit"
    type     = "VARCHAR(16777216)"
    nullable = true
  }

  column {
    name     = "country_code_3_digit"
    type     = "VARCHAR(16777216)"
    nullable = true
  }

  column {
    name     = "population"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "cases_count"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "deaths_count"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "year"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "week"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "source"
    type     = "VARCHAR(16777216)"
    nullable = true
  }

  primary_key {
    name = "my_key"
    keys = ["country"]
  }

}

#Create a view on the above table
resource "snowflake_view" "tets_view" {
  database = snowflake_database.DB-DATAENGINEERS.name
  schema   = snowflake_schema.test_schema.name
  name     = "TEST_VIEW"

  comment = "Creating a test view"

  statement  = <<-SQL
    select * from ${snowflake_table.cases_death.name};
SQL
  or_replace = true
}

#Granting DEs access to the schema and tables within that Schema
resource "snowflake_schema_grant" "GRANT-SCHEMA-DATA-ENGINEERS" {
  database_name = snowflake_database.DB-DATAENGINEERS.name
  schema_name   = snowflake_schema.test_schema.name

  privilege         = "USAGE"
  roles             = [snowflake_role.Data-Engineering.name]
  with_grant_option = false
}

#Granting DEs access to the table defined above:
resource "snowflake_table_grant" "GRANT-TABLE-DATA-ENGINEERS" {
  database_name = snowflake_database.DB-DATAENGINEERS.name
  schema_name   = snowflake_schema.test_schema.name
  table_name    = snowflake_table.cases_death.name
  privilege     = "SELECT"
  roles         = [snowflake_role.Data-Engineering.name]

  #The DE role will have access to all future tables within the specified schema
  with_grant_option = false
}

#Granting DEs access to the view defined above:
resource "snowflake_view_grant" "GRANT-VIEW-DATA-ENGINEERS" {
  database_name = snowflake_database.DB-DATAENGINEERS.name
  schema_name   = snowflake_schema.test_schema.name
  # view_name     = snowflake_view.tets_view.name
  privilege = "SELECT"
  roles     = [snowflake_role.Data-Engineering.name]

  on_future         = true
  with_grant_option = false
}