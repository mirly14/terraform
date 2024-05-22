# -- Data Warehouse -- #

resource "snowflake_warehouse" "warehouse_test" {
  provider = snowflake.accountadmin
  name           = "WH_TEST" # *required* ~ This name should be unique for account
  comment        = "The size of the WH can be changed"
  warehouse_size = "small" # x-small | small | medium | large | x-large
  initially_suspended = true # Accepted values true | false
  auto_resume = true # Accepted values true | false ~ It will be resumed after a query is run
  auto_suspend = 120 # This time is in seconds
}

resource "snowflake_grant_privileges_to_account_role" "grant_wh_to_role" {
  provider = snowflake.accountadmin
  privileges        = ["MODIFY", "OPERATE", "MONITOR"] # It could be any of the Snowflake Warehouse Privileges
  account_role_name = snowflake_role.beta_role.name # *required*
  on_account_object {
    object_type = "WAREHOUSE" # Accepted values USER | RESOURCE MONITOR | WAREHOUSE | COMPUTE POOL | DATABASE | INTEGRATION | FAILOVER GROUP | REPLICATION GROUP | EXTERNAL VOLUME
    object_name = snowflake_warehouse.warehouse_test.name # Refers to the Warehouse created on previous steps
  }
}
