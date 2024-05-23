# -- Stage Management -- # 

# If you want to see how to use variables, please refer to the account_management.tf files

resource "snowflake_stage" "example_stage" {
  provider = snowflake.accountadmin
  name        = "STAGE_TEST" # *required*
  database    = snowflake_database.simple.name # *required*
  schema      = snowflake_schema.schema_example.name # *required* ~ Mandatory to use only the schema name betweeen quotes ""
  directory   = "ENABLE = true" # a null value here forces replacement of the stage each time terraform apply is run
}

resource "snowflake_grant_privileges_to_account_role" "grant_stage_to_role" {
  provider = snowflake.accountadmin
  privileges        = ["READ", "WRITE"] # It could be any of the Snowflake Stage Privileges: "READ", "WRITE"
  account_role_name = snowflake_role.beta_role.name
  on_schema_object {
    object_type = "STAGE" # Accepted values AGGREGATION POLICY | ALERT | AUTHENTICATION POLICY | DATA METRIC FUNCTION | DYNAMIC TABLE | EVENT TABLE | EXTERNAL TABLE | FILE FORMAT | FUNCTION | GIT REPOSITORY | HYBRID TABLE | IMAGE REPOSITORY | ICEBERG TABLE | MASKING POLICY | MATERIALIZED VIEW | MODEL | NETWORK RULE | PACKAGES POLICY | PASSWORD POLICY | PIPE | PROCEDURE | PROJECTION POLICY | ROW ACCESS POLICY | SECRET | SERVICE | SESSION POLICY | SEQUENCE | STAGE | STREAM | TABLE | TAG | TASK | VIEW | STREAMLIT
    object_name = "\"${snowflake_database.simple.name}\".\"SCHEMA_TEST\".\"STAGE_TEST\"" # The fully qualified name of the object on which privileges will be granted
  }
  depends_on = [
    snowflake_stage.example_stage
  ]
} 
