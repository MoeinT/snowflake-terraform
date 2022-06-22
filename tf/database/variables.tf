variable "DB_name" {
   type  = string
}

variable "DB_grant_roles" {
   type  = map(any)
}

variable "DB_data_retention_time_in_days" {
   type = number
   default = 1
}

variable "schema_names" {
   type = list(string)
}

variable "schema_grants" {
   type = map(any)
}

variable "SCHEMA_data_retention_days" {
   type = number
   default = 1 
}

variable "SCHEMA_with_grant_option" {
   type = bool
   default = false
}