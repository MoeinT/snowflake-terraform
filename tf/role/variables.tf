variable "role_name" {
  type = string
}

variable "role_grant_to" {
  type    = list(string)
  default = ["ACCOUNTADMIN"]
}