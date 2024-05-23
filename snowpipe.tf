# -- Snowpipe Management --# 

# If you want to see how to use variables, please refer to the account_management.tf file

resource "snowflake_pipe" "pipe" {
  provider = snowflake.accountadmin
  database = snowflake_database.simple.name # *required*
  schema   = "TEST_SCHEMA" # *required*
  name     = "TEST_PIPE" # *required*
  comment = "A pipe"

  copy_statement =  "copy into SF_DB_TEST.TEST_SCHEMA.STAGE_TABLE FROM @SF_DB_TEST.TEST_SCHEMA.EXAMPLE_STAGE_SF" # *required* ~ Specifies the copy statement for the pipe
  auto_ingest    = false # Accepted values true | false
 
  # aws_sns_topic_arn    = "..." # Specifies the Amazon Resource Name (ARN) for the SNS topic for your S3 bucket
  # notification_channel = "..." # Amazon Resource Name of the Amazon SQS queue for the stage named in the DEFINITION column
}

resource "snowflake_grant_privileges_to_account_role" "grant_pipe_to_role" {
  provider = snowflake.accountadmin
  privileges        = ["OPERATE", "MONITOR"] # pipes privileges given by snowflake
  account_role_name = snowflake_role.example_role.name
  on_schema_object {
    object_type = "PIPE" # Accepted values AGGREGATION POLICY | ALERT | AUTHENTICATION POLICY | DATA METRIC FUNCTION | DYNAMIC TABLE | EVENT TABLE | EXTERNAL TABLE | FILE FORMAT | FUNCTION | GIT REPOSITORY | HYBRID TABLE | IMAGE REPOSITORY | ICEBERG TABLE | MASKING POLICY | MATERIALIZED VIEW | MODEL | NETWORK RULE | PACKAGES POLICY | PASSWORD POLICY | PIPE | PROCEDURE | PROJECTION POLICY | ROW ACCESS POLICY | SECRET | SERVICE | SESSION POLICY | SEQUENCE | STAGE | STREAM | TABLE | TAG | TASK | VIEW | STREAMLIT
    object_name =  "\"${snowflake_database.simple.name}\".\"TEST_SCHEMA\".\"TEST_PIPE\"" # The fully qualified name of the object on which privileges will be granted
  }
}
