# -- Schema Management -- #

# If you want to see how to use variables, please refer to the account_management.tf file

resource "snowflake_schema" "schema_example" {
  provider = snowflake.accountadmin # This is the provider that uses the sysadmin role created before (Providers Section above)
  database = snowflake_database.simple.name # *required*
  name     = "SCHEMA_TEST" # *required*
  is_transient        = false # Accepted values true | false ~ Transient schemas do not have a Fail-safe period so they do not incur additional storage costs once they leave Time Travel
  is_managed          = false # Accepted values true | false ~ Managed access schemas centralize privilege management with the schema owner
  data_retention_days = 1 # Number of days for which Snowflake retains historical data for performing Time Travel actions
} 

resource "snowflake_grant_privileges_to_account_role" "schema" {
  provider = snowflake.accountadmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_role.beta_role.name
  on_schema {
    schema_name = "\"${snowflake_database.simple.name}\".\"TEST_SCHEMA\"" # note this is a fully qualified name!
  }
  depends_on = [
    snowflake_schema.schema_example
  ]
}
