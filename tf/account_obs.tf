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

#Creating a medium warehouse for data engineering
resource "snowflake_warehouse" "Data_Engineers_Medium_WH" {
  name                = "DATA_ENGINEERS_WH_Medium"
  comment             = "Creating a Medium warehouse for DEs"
  warehouse_size      = "Medium"
  auto_resume         = true
  auto_suspend        = 60
  max_cluster_count   = 3
  min_cluster_count   = 1
  scaling_policy      = "ECONOMY"
  initially_suspended = true
}


#Creating account-level objects:
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

# #Create a marketing role:
resource "snowflake_role" "MARKETING" {
  name    = "MARKETING"
  comment = "A role for all in marketing"
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

resource "snowflake_warehouse_grant" "GRANT-WH-MEDIUM-DATA-ENIGINEERS" {
  warehouse_name = snowflake_warehouse.Data_Engineers_Medium_WH.name
  privilege      = "USAGE"

  roles = [
    snowflake_role.Data-Engineering.name
  ]

  with_grant_option = false
}

#GraNting DEs access to a our DB
resource "snowflake_database_grant" "GRANT-DB-DATA-ENGINEERS" {
  database_name = snowflake_database.DB-DATAENGINEERS.name

  privilege         = "USAGE"
  roles             = [snowflake_role.Data-Engineering.name]
  with_grant_option = false
}