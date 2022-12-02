variable "snowflake_user" {
  type        = string
  description = "The snowflake user you have created for this project"
}

variable "snowflake_account" {
  type        = string
  description = "The snowflake account you are working on"
}

variable "private_key_path" {
  type        = string
  description = "Path to the private key file"
}

variable "snowflake_region" {
  type        = string
  description = "The snowflake region you are working on"
}
