variable "name" {
  type = string
}

variable "database" {
  type = string
}

variable "schema" {
  type = string
}

variable "data_type" {
  type = string
}

variable "masking_expression" {
  type = string
}

variable "with_grant_option" {
  type    = bool
  default = false
}

variable "masking_grants" {
  type = map(any)
}