terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
    }
  }
}

provider "snowflake" {
  role = "SYSADMIN"
}

resource "snowflake" "snoflake_warehouse" {
  name           = "jhonathan_tf_demo_warehouse"
  warehouse_size = "large"

  auto_suspend = 60
}

resource "snowflake" "snowflake_db" {
  name = "jhonathan_tf_demo_db"

}

