variable "DB_name" {
  type = string
}

variable "DB_data_retention_time_in_days" {
  type    = number
  default = 1
}

variable "DB_privilege" {
  type    = string
  default = "USAGE"
}

variable "DB_with_grant_option" {
  type    = bool
  default = false
}

variable "DB_grant_roles" {
  type = map(any)
}

# variable "schema_names" {
#   type = list(string)
# }

# variable "SCHEMA_grant_roles" {
#   type = map(any)
# }

# variable "schema_privilege" {
#   type    = string
#   default = "USAGE"
# }

variable "schema_with_grant_option" {
  type    = bool
  default = false
}

variable "schema_data_retention_days" {
  type    = number
  default = 1
}

variable "schemas" {
  type = list(string)
}

variable "schema_grants" {
  type = map(any)
}