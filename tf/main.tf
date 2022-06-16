terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = ">= 0.25.18"
    }
  }
}

provider "snowflake" {
  username = var.username
  account  = var.account
  role     = "ACCOUNTADMIN"
  password = var.password
}

#Create a database in Snowflake 
resource "snowflake_database" "test-db" {
  name    = "TEST_DB_TERRAFORM"
  comment = "My firs db with Terraform"
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

  default_warehouse    = "TEST_WH"
  default_role         = "ACCOUNTADMIN"
  must_change_password = true
}


#Creating a role: 
resource "snowflake_role" "Data-Engineering" {
  name    = "Data Engineering"
  comment = "A role for all Data Engineers"
}





