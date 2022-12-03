terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
    version = "~> 0.35" }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }

}


provider "snowflake" {
  alias            = "security_admin"
  role             = "SECURITYADMIN"
  username         = var.snowflake_user
  account          = var.snowflake_account
  private_key_path = var.private_key_path
  region           = var.snowflake_region
}

provider "snowflake" {
  role             = "SYSADMIN"
  username         = var.snowflake_user
  account          = var.snowflake_account
  private_key_path = var.private_key_path
  region           = var.snowflake_region
}


resource "snowflake_role" "role" {
  provider = snowflake.security_admin
  name     = "TF_SVCR_ROLE_JHONATHAN"
}

resource "snowflake_warehouse" "warehouse" {
  name           = "jhonathan_tf_demo_warehouse"
  warehouse_size = "large"

  auto_suspend = 60
}

resource "snowflake_schema" "schema" {
  database = snowflake_database.database.name
  name     = "TF_DEMO_JHONATHAN"

  is_managed = false
}
resource "snowflake_database" "database" {
  name = "jhonathan_tf_demo_db"
}

resource "snowflake_database_grant" "grant" {
  provider      = snowflake.security_admin
  database_name = snowflake_database.database.name
  privilege     = "USAGE"
  roles         = [snowflake_role.role.name]

  with_grant_option = false
}

resource "snowflake_warehouse_grant" "grant" {
  provider       = snowflake.security_admin
  warehouse_name = snowflake_warehouse.warehouse.name
  privilege      = "USAGE"
  roles          = [snowflake_role.role.name]

  with_grant_option = false
}

resource "snowflake_schema_grant" "grant" {
  provider      = snowflake.security_admin
  database_name = snowflake_database.database.name
  schema_name   = snowflake_schema.schema.name
  privilege     = "USAGE"
  roles         = [snowflake_role.role.name]

  with_grant_option = false
}
resource "tls_private_key" "svc_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "snowflake_user" "user" {
  provider          = snowflake.security_admin
  name              = "tf_demo_user"
  default_warehouse = snowflake_warehouse.warehouse.name
  default_role      = snowflake_role.role.name
  default_namespace = "${snowflake_database.database.name}.${snowflake_schema.schema.name}"
  rsa_public_key    = substr(tls_private_key.svc_key.public_key_pem, 27, 398)
}
resource "snowflake_role_grants" "grants" {
  provider  = snowflake.security_admin
  role_name = snowflake_role.role.name
  users     = [snowflake_user.user.name]
}
