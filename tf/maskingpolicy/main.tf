terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = ">= 0.25.18"
    }
  }
}

resource "snowflake_masking_policy" "MASKING-POLICY" {
  name               = var.name
  database           = var.database
  schema             = var.schema
  value_data_type    = var.data_type
  masking_expression = var.masking_expression
  return_data_type   = var.data_type
}

resource "snowflake_masking_policy_grant" "MASKING-GRANT" {
  for_each            = var.masking_grants
  database_name       = snowflake_masking_policy.MASKING-POLICY.database
  masking_policy_name = snowflake_masking_policy.MASKING-POLICY.name
  schema_name         = snowflake_masking_policy.MASKING-POLICY.schema
  privilege           = each.key
  roles               = each.value
  with_grant_option   = var.with_grant_option
}

output "masking_policy" {
  value = snowflake_masking_policy.MASKING-POLICY.name
}