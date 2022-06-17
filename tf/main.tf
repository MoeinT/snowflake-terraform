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