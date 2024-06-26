# -- Database Management -- #

# If you want to see how to use variables, please refer to the account_management.tf file

resource "snowflake_database" "simple" {
  provider = snowflake
  name = "DB_TEST" # *required*
  comment = "This database will be used for testing code"
  data_retention_time_in_days = 3 # Number of days for which Snowflake retains historical data for performing Time Travel actions
}

resource "snowflake_grant_privileges_to_account_role" "grant_db_to_role" {
  provider = snowflake
  privileges        = ["CREATE SCHEMA", "CREATE DATABASE ROLE", "USAGE"] # It could be any of the Snowflake Database Privileges
  account_role_name = snowflake_role.beta_role.name # *required*
  on_account_object {
    object_type = "DATABASE" # Accepted values USER | RESOURCE MONITOR | WAREHOUSE | COMPUTE POOL | DATABASE | INTEGRATION | FAILOVER GROUP | REPLICATION GROUP | EXTERNAL VOLUME
    object_name = snowflake_database.simple.name # Refers to the Database created on previous steps
  }
}

#--Argument used to specify explicit dependencies between resources
#  depends_on = [
#     snowflake_database.simple  #name of the resource
#   ]
# } 

# This section allows you to print specific code from your resource in the console

# output "copy_statement_pipe" {
#   value = snowflake_pipe.pipe.copy_statement # Add the resource you want to see
# }
