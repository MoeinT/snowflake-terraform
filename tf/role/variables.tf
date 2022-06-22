variable "role_name" {
  type = list(string)
}

variable "role_grant_to" {
  type    = list(string)
  default = ["ACCOUNTADMIN"]
}