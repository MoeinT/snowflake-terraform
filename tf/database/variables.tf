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

variable "DB_roles" {
  type = list(string)
}

variable "DB_with_grant_option" {
  type    = bool
  default = false
}



