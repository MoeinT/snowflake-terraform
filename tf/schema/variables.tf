variable "schema_databasename" {
  type = string
}

variable "schema_name" {
  type = string
}

variable "schema_data_retention_days" {
  type    = number
  default = 1
}

variable "schema_privilege" {
  type    = string
  default = "USAGE"
}

variable "schema_snowflake_role" {
  type = list(string)
}

variable "schema_with_grant_option" {
  type    = bool
  default = false
}
