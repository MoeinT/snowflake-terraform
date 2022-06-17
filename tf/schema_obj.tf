#Create schema lever objects in this file
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
