#The main.tf file states what resources to create when you're calling this warehouse
terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = ">= 0.25.18"
    }
  }
}

#Creating a warehouse whenever this module is called
resource "snowflake_warehouse" "WAREHOUSE" {
  name                = var.warehouse_name
  warehouse_size      = var.warehouse_size
  auto_resume         = var.warehouse_auto_resume
  auto_suspend        = var.warehouse_auto_suspend
  max_cluster_count   = var.warehouse_max_cluster_count
  min_cluster_count   = var.warehouse_min_cluster_count
  scaling_policy      = var.warehouse_scaling_policy
  initially_suspended = var.warehouse_initially_suspended
}

#Giving grants to the warehouse whenever the module is called
resource "snowflake_warehouse_grant" "GRANT-WAREHOUSE" {
  warehouse_name = snowflake_warehouse.WAREHOUSE.name
  privilege      = var.warehouse_grant_priviledge
  roles = var.snowflake_role
  with_grant_option = var.snowflake_role_with_grant_option
}