terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
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

resource "snowflake_warehouse" "warehouse" {
  name           = "jhonathan_tf_demo_warehouse"
  warehouse_size = "large"

  auto_suspend = 60
}

resource "snowflake_database" "database" {
  name = "jhonathan_tf_demo_db"

}

