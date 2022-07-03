variable "snowflake_password" {
  type      = string
  sensitive = true
}

variable "snowflake_username" {
  type      = string
  sensitive = true
}

variable "snowflake_account" {
  type      = string
  sensitive = true
}

variable "name" {
  type    = string
  default = "Moein"
}