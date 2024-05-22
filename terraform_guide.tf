# ***

# To init your Terraform guide, run terraform init
# To see the objects your going to create, run terraform plan
# To apply those objects in your Snowflake account, run terraform apply
# If you want to remove an object, run terraform destroy

# ***

# This is a terraform provider plugin for managing Snowflake accounts

terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake" # This variable does not change. It is unique for the Snowflake plugin
      version = "~> 0.90.0" # This is the most recent version of the plugin
    }
  }
}

# -- Providers -- #

# Here goes the credentials to connect to your Snowflake account
# It is a best practice to write any name with capitalize letters (e.g. user name, schema name, and so on)

provider "snowflake" {
  user = "USER_ACCOUNT" # *required*
  password = "Abc12345"  # *required*
  account  = "EQB69117" # *required* ~ This is the account locator number in Snowflake
  role = "SYSADMIN"
  region = "us-east-1" # Only necessary for this element
}

provider "snowflake" {
  alias = "orgadmin"
  user = "USER_ACCOUNT" # *required*
  password = "Abc12345" # *required*
  account  = "EQB69117" # *required* 
  role = "ORGADMIN"
  region = "us-east-1" 
}

provider "snowflake" {
  alias = "accountadmin" # You can specify an alias for each to differentiate (securityadmin | sysadmin | public | custom_roles )
  user = "USER_ACCOUNT" # *required*
  password = "Abc12345"  # *required*
  account  = "EQB69117" # *required*
  role = "ACCOUNTADMIN"
  region = "us-east-1"
}  

# -- Account Management -- # 

# ORGADMIN priviliges are required for this resource, only for creating the account for the admin. 

resource "snowflake_account" "beta_account" { 
  provider = snowflake.orgadmin # It depends on the provider you created
  name                 = "ACCOUNT_NAME" # *required* ~ Only capital letters, numbers and underscores
  admin_name           = "ADMIN_NAME" # *required*
  admin_password       = "ABC1234"
  email                = "name.lastname@gmail.com" # *required*
  must_change_password = true # Accepted values true | false ~ Every new account is forced to change password the fisrt time they sign in
  edition              = "ENTERPRISE" # *required* ~ Accepted values STANDARD | ENTERPRISE | BUSINESS_CRITICAL
  comment              = "Testing account functionality"
} 

resource "snowflake_grant_privileges_to_account_role" "example_account" {
  provider = snowflake.accountadmin
  privileges        = ["CREATE DATABASE", "CREATE USER"] # It could be any of the Snowflake Global Privileges ~ ["CREATE USER"]
  account_role_name = "ACCOUNTADMIN" # *required* ~ This is the name of the role you want to grant privileges 
  on_account        = true # Accepted values true | false ~ If true, the privileges will be granted on the account
}

# -- Snowflake User -- #

# This creates the users that all the different persons are going to use when Signing in Snowflake with their corresponding roles.   

resource "snowflake_user" "user_beta" {
  provider = snowflake.accountadmin
  name         = "TEST_USER" # *required* ~ Note that if you do not supply login_name this will be used as login name, name that appears in snowflake
  login_name   = "USER" # name used to login 
  comment      = "A Snowflake user"
  password     = "Password123" # It should contain a one capilized letter
  disabled     = false # Accepted values true | false
  email        = "name.lastname@gmail.com"

  default_warehouse       = "COMPUTE_WH" # Specifies the virtual warehouse that is active by default for the user’s session upon login
  default_secondary_roles = ["ALL"] # Specifies the set of secondary roles that are active for the user’s session upon login. Currently only ["ALL"] value is supported
  default_role            = "PUBLIC" # Specifies the role that is active by default for the user’s session upon login

  must_change_password = false # Accepted values true | false ~ Every new account is forced to change password the fisrt time they sign in

  # rsa_public_key   = "..." # Specifies the user’s RSA public key; used for key-pair authentication. Must be on 1 line without header and trailer
  # rsa_public_key_2 = "..." # Specifies the user’s second RSA public key; used to rotate the public and private keys for key-pair authentication based on an expiration schedule set by your organization
} 

# -- Snowflake Role -- #

# Remenber, when you create a new role it is not automatically assigned to your user account, you have to do that manually or usign the snowflake_grant_account_role resource

resource "snowflake_role" "beta_role" {
  provider = snowflake.accountadmin
  name    = "ROLE_DEVELOPER" # *required*
  comment = "A role"
}

resource "snowflake_grant_account_role" "grant_role_to_user" {
  provider = snowflake.accountadmin
  role_name = snowflake_role.beta_role.name # *required*
  user_name = snowflake_user.user_beta.name # *required*
}

# -- Database -- #

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

# -- Schema -- #

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

# -- Stage -- # 

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

# -- Snowpipe --# 

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

# -------

# This section allows you to print specific code from your resource in the console

# output "copy_statement_pipe" {
#   value = snowflake_pipe.pipe.copy_statement # Add the resource you want to see
# }

# -------

# -- Storage Integration -- #

# resource "snowflake_storage_integration" "integration" {
#   name    = "storage" # *required*
#   comment = "A storage integration."
#   type    = "EXTERNAL_STAGE" # Accepted values EXTERNAL_STAGE | INTERNAL_STAGE

#   enabled = true # Accepted values true | false

#   storage_allowed_locations = [""] #*required*
#   storage_blocked_locations = [""] # Explicitly prohibits external stages that use the integration from referencing one or more storage locations
#   storage_aws_object_acl    = "bucket-owner-full-control" # Enables support for AWS access control lists (ACLs) to grant the bucket owner full control

#   storage_provider         = "S3" # *required*
#   storage_aws_external_id  = "..." # The external ID that Snowflake will use when assuming the AWS role
#   storage_aws_iam_user_arn = "..." # he Snowflake user that will attempt to assume the AWS role
#   storage_aws_role_arn     = "..." # 
  
#   # azure_tenant_id  
# }

# -- Notification Integration -- #

# resource "snowflake_notification_integration" "integration" {
#   name    = "notification" # *required*
#   comment = "A notification integration"
#   enabled   = true # Accepted values true | false
  
#   # AWS_SQS
#   notification_provider = "AWS_SQS" # *required* ~ Accepted values AZURE_STORAGE_QUEUE | AWS_SNS | GCP_PUBSUB
#   aws_sqs_arn           = "..." */ # AWS SQS queue ARN for notification integration to connect to
  
#   # AZURE_STORAGE_QUEUE
#   # notification_provider           = "AZURE_STORAGE_QUEUE" 
#   # azure_storage_queue_primary_uri = "..."
#   # azure_tenant_id                 = "..."

#   # AWS_SNS
#   # notification_provider = "AWS_SNS"
#   # aws_sns_topic_arn     = "..."
# }

# -- Grant Ownership -- #

# For RBAC 

# resource snowflake_role TEST_DB_TEST_SCHEMA_R_AR {
#   name = "TEST_DB_TEST_SCHEMA_R_AR"
# }

# resource snowflake_role_ownership_grant role_test_db_test_schema_r_ar_ownership_grant {
#   on_role_name = snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name
#   to_role_name = "USERADMIN"
#   revert_ownership_to_role_name = "SYSADMIN"
# }

# resource snowflake_role TEST_DB_TEST_SCHEMA_RW_AR {
#   name = "TEST_DB_TEST_SCHEMA_RW_AR"
# }

# resource snowflake_role_ownership_grant role_test_db_test_schema_rw_ar_ownership_grant {
#   on_role_name = snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name
#   to_role_name = "USERADMIN"
#   revert_ownership_to_role_name = "SYSADMIN"
# }

# resource snowflake_role TEST_DB_TEST_SCHEMA_FULL_AR {
#   name = "TEST_DB_TEST_SCHEMA_FULL_AR"
# }

# resource snowflake_role_ownership_grant role_test_db_test_schema_full_ar_ownership_grant {
#   on_role_name = snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name
#   to_role_name = "USERADMIN"
#   revert_ownership_to_role_name = "SYSADMIN"
# }

# resource snowflake_role TEST_WH_U_AR {
#   name = "TEST_WH_U_AR"
# }

# resource snowflake_role_ownership_grant role_test_wh_u_ar_ownership_grant {
#   on_role_name = snowflake_role.TEST_WH_U_AR.name
#   to_role_name = "USERADMIN"
#   revert_ownership_to_role_name = "SYSADMIN"
# }

# resource snowflake_role TEST_WH_UM_AR {
#   name = "TEST_WH_UM_AR"
# }

# resource snowflake_role_ownership_grant role_test_wh_um_ar_ownership_grant {
#   on_role_name = snowflake_role.TEST_WH_UM_AR.name
#   to_role_name = "USERADMIN"
#   revert_ownership_to_role_name = "SYSADMIN"
# }

# resource snowflake_role TEST_WH_FULL_AR {
#   name = "TEST_WH_FULL_AR"
# }

# resource snowflake_role_ownership_grant role_test_wh_full_ar_ownership_grant {
#   on_role_name = snowflake_role.TEST_WH_FULL_AR.name
#   to_role_name = "USERADMIN"
#   revert_ownership_to_role_name = "SYSADMIN"
# }

# resource snowflake_database_grant grant_usage_on_test_db_database {
#   database_name = snowflake_database.TEST_DB.name
#   privilege = "USAGE"
#   roles = ["TEST_DB_TEST_SCHEMA_R_AR", "TEST_DB_TEST_SCHEMA_RW_AR", "TEST_DB_TEST_SCHEMA_FULL_AR", "TEST_DB_TEST_SCHEMA_FULL_AR"]

#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant]
# }

# resource snowflake_schema_grant grant_usage_on_test_db__test_schema_schema {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   depends_on = [snowflake_role_grants.role_test_db_test_schema_r_ar_grants, snowflake_role_grants.role_test_db_test_schema_rw_ar_grants, snowflake_role_grants.role_test_db_test_schema_full_ar_grants, snowflake_role_grants.role_test_db_test_schema_full_ar_grants, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant]

#   with_grant_option = false
#   enable_multiple_grants = true
# }

# resource snowflake_schema_grant grant_ownership_on_test_db__test_schema_schema {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   depends_on = [snowflake_role_grants.role_test_db_test_schema_full_ar_grants, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]

#   with_grant_option = false
#   enable_multiple_grants = true
# }

# resource snowflake_table_grant grant_select_on_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "SELECT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_select_on_future_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "SELECT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_insert_on_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "INSERT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_update_on_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "UPDATE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_delete_on_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "DELETE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_references_on_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "REFERENCES"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_insert_on_future_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "INSERT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_update_on_future_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "UPDATE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_delete_on_future_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "DELETE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_references_on_future_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "REFERENCES"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_ownership_on_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_table_grant grant_ownership_on_future_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_view_grant grant_select_on_test_db__test_schema_views {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "SELECT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_view_grant.grant_ownership_on_test_db__test_schema_views]
# }

# resource snowflake_view_grant grant_select_on_future_test_db__test_schema_views {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "SELECT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_view_grant.grant_ownership_on_test_db__test_schema_views]
# }

# resource snowflake_view_grant grant_ownership_on_test_db__test_schema_views {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_view_grant grant_ownership_on_future_test_db__test_schema_views {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_view_grant.grant_ownership_on_test_db__test_schema_views]
# }

# resource snowflake_sequence_grant grant_usage_on_test_db__test_schema_sequences {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_sequence_grant.grant_ownership_on_test_db__test_schema_sequences]
# }

# resource snowflake_sequence_grant grant_usage_on_future_test_db__test_schema_sequences {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_sequence_grant.grant_ownership_on_test_db__test_schema_sequences]
# }

# resource snowflake_sequence_grant grant_ownership_on_test_db__test_schema_sequences {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_sequence_grant grant_ownership_on_future_test_db__test_schema_sequences {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_sequence_grant.grant_ownership_on_test_db__test_schema_sequences]
# }

# resource snowflake_stage_grant grant_usage_on_test_db__test_schema_stages {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_stage_grant.grant_ownership_on_test_db__test_schema_stages]
# }

# resource snowflake_stage_grant grant_read_on_test_db__test_schema_stages {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "READ"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_stage_grant.grant_ownership_on_test_db__test_schema_stages]
# }

# resource snowflake_stage_grant grant_usage_on_future_test_db__test_schema_stages {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_stage_grant.grant_ownership_on_test_db__test_schema_stages]
# }

# resource snowflake_stage_grant grant_read_on_future_test_db__test_schema_stages {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "READ"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_stage_grant.grant_ownership_on_test_db__test_schema_stages]
# }

# resource snowflake_stage_grant grant_write_on_future_test_db__test_schema_stages {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "WRITE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_stage_grant.grant_usage_on_future_test_db__test_schema_stages, snowflake_stage_grant.grant_read_on_future_test_db__test_schema_stages, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_stage_grant.grant_ownership_on_test_db__test_schema_stages]
# }

# resource snowflake_stage_grant grant_write_on_test_db__test_schema_stages {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "WRITE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_stage_grant.grant_ownership_on_test_db__test_schema_stages]
# }

# resource snowflake_stage_grant grant_ownership_on_test_db__test_schema_stages {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_stage_grant grant_ownership_on_future_test_db__test_schema_stages {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_stage_grant.grant_ownership_on_test_db__test_schema_stages]
# }

# resource snowflake_file_format_grant grant_usage_on_test_db__test_schema_file_formats {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_file_format_grant.grant_ownership_on_test_db__test_schema_file_formats]
# }

# resource snowflake_file_format_grant grant_usage_on_future_test_db__test_schema_file_formats {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_file_format_grant.grant_ownership_on_test_db__test_schema_file_formats]
# }

# resource snowflake_file_format_grant grant_ownership_on_test_db__test_schema_file_formats {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_file_format_grant grant_ownership_on_future_test_db__test_schema_file_formats {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_file_format_grant.grant_ownership_on_test_db__test_schema_file_formats]
# }

# resource snowflake_stream_grant grant_select_on_test_db__test_schema_streams {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "SELECT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_stream_grant.grant_ownership_on_test_db__test_schema_streams]
# }

# resource snowflake_stream_grant grant_select_on_future_test_db__test_schema_streams {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "SELECT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_stream_grant.grant_ownership_on_test_db__test_schema_streams]
# }

# resource snowflake_stream_grant grant_ownership_on_test_db__test_schema_streams {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_stream_grant grant_ownership_on_future_test_db__test_schema_streams {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_stream_grant.grant_ownership_on_test_db__test_schema_streams]
# }

# resource snowflake_procedure_grant grant_usage_on_test_db__test_schema_procedures {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_procedure_grant.grant_ownership_on_test_db__test_schema_procedures]
# }

# resource snowflake_procedure_grant grant_usage_on_future_test_db__test_schema_procedures {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_procedure_grant.grant_ownership_on_test_db__test_schema_procedures]
# }

# resource snowflake_procedure_grant grant_ownership_on_test_db__test_schema_procedures {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_procedure_grant grant_ownership_on_future_test_db__test_schema_procedures {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_procedure_grant.grant_ownership_on_test_db__test_schema_procedures]
# }

# resource snowflake_function_grant grant_usage_on_test_db__test_schema_functions {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_function_grant.grant_ownership_on_test_db__test_schema_functions]
# }

# resource snowflake_function_grant grant_usage_on_future_test_db__test_schema_functions {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_function_grant.grant_ownership_on_test_db__test_schema_functions]
# }

# resource snowflake_function_grant grant_ownership_on_test_db__test_schema_functions {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_function_grant grant_ownership_on_future_test_db__test_schema_functions {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_function_grant.grant_ownership_on_test_db__test_schema_functions]
# }

# resource snowflake_materialized_view_grant grant_select_on_test_db__test_schema_materialized_views {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "SELECT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_materialized_view_grant.grant_ownership_on_test_db__test_schema_materialized_views]
# }

# resource snowflake_materialized_view_grant grant_select_on_future_test_db__test_schema_materialized_views {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "SELECT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_materialized_view_grant.grant_ownership_on_test_db__test_schema_materialized_views]
# }

# resource snowflake_materialized_view_grant grant_ownership_on_test_db__test_schema_materialized_views {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_materialized_view_grant grant_ownership_on_future_test_db__test_schema_materialized_views {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_materialized_view_grant.grant_ownership_on_test_db__test_schema_materialized_views]
# }

# resource snowflake_task_grant grant_monitor_on_test_db__test_schema_tasks {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "MONITOR"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_task_grant.grant_ownership_on_test_db__test_schema_tasks]
# }

# resource snowflake_task_grant grant_operate_on_test_db__test_schema_tasks {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OPERATE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_task_grant.grant_ownership_on_test_db__test_schema_tasks]
# }

# resource snowflake_task_grant grant_monitor_on_future_test_db__test_schema_tasks {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "MONITOR"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_task_grant.grant_ownership_on_test_db__test_schema_tasks]
# }

# resource snowflake_task_grant grant_operate_on_future_test_db__test_schema_tasks {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OPERATE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_task_grant.grant_ownership_on_test_db__test_schema_tasks]
# }

# resource snowflake_task_grant grant_ownership_on_test_db__test_schema_tasks {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_task_grant grant_ownership_on_future_test_db__test_schema_tasks {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_task_grant.grant_ownership_on_test_db__test_schema_tasks]
# }

# resource snowflake_warehouse_grant grant_usage_on_warehouse_test_wh {
#   warehouse_name = snowflake_warehouse.TEST_WH.name
#   privilege = "USAGE"

#   roles = [snowflake_role.TEST_WH_U_AR.name, snowflake_role.TEST_WH_UM_AR.name]

#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_role_ownership_grant.role_test_wh_u_ar_ownership_grant]
# }

# resource snowflake_warehouse_grant grant_monitor_on_warehouse_test_wh {
#   warehouse_name = snowflake_warehouse.TEST_WH.name
#   privilege = "MONITOR"

#   roles = [snowflake_role.TEST_WH_UM_AR.name]

#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_role_ownership_grant.role_test_wh_um_ar_ownership_grant]
# }

# resource snowflake_warehouse_grant grant_ownership_on_warehouse_test_wh {
#   warehouse_name = snowflake_warehouse.TEST_WH.name
#   privilege = "OWNERSHIP"

#   roles = [snowflake_role.TEST_WH_FULL_AR.name]

#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_role_ownership_grant.role_test_wh_full_ar_ownership_grant]
# }

# resource snowflake_role_grants role_test_db_test_schema_r_ar_grants {
#   role_name = snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name

#   enable_multiple_grants = true
#   roles = [
#     "SYSADMIN",
#   ]
# }

# resource snowflake_role_grants role_test_db_test_schema_rw_ar_grants {
#   role_name = snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name

#   enable_multiple_grants = true
#   roles = [
#     "SYSADMIN",
#   ]
# }

# resource snowflake_role_grants role_test_db_test_schema_full_ar_grants {
#   role_name = snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name

#   enable_multiple_grants = true
#   roles = [
#     "SYSADMIN",
#     snowflake_role.BETA_DEVELOPER.name,
#   ]
# }

# resource snowflake_role_grants role_test_wh_u_ar_grants {
#   role_name = snowflake_role.TEST_WH_U_AR.name

#   enable_multiple_grants = true
#   roles = [
#     "SYSADMIN",
#     snowflake_role.BETA_DEVELOPER.name,
#   ]
# }

# resource snowflake_role_grants role_test_wh_um_ar_grants {
#   role_name = snowflake_role.TEST_WH_UM_AR.name

#   enable_multiple_grants = true
#   roles = [
#     "SYSADMIN",
#   ]
# }

# resource snowflake_role_grants role_test_wh_full_ar_grants {
#   role_name = snowflake_role.TEST_WH_FULL_AR.name

#   enable_multiple_grants = true
#   roles = [
#     "SYSADMIN",
#   ]
# }

# resource "snowflake_role" "test" {
#   name = "role"
# }

# resource "snowflake_database" "test" {
#   name = "database"
# }

# resource "snowflake_grant_ownership" "test" {
#   account_role_name = snowflake_role.test.name
#   on {
#     object_type = "DATABASE"
#     object_name = snowflake_database.test.name
#   }
# }

# resource "snowflake_grant_account_role" "test" {
#   role_name = snowflake_role.test.name
#   user_name = "username"
# }

# provider "snowflake" {
#   profile = "default"
#   alias   = "secondary"
#   role    = snowflake_role.test.name
# }
 
# With ownership on the database, the secondary provider is able to create schema on it without any additional privileges

# resource "snowflake_schema" "test" {
#   depends_on = [snowflake_grant_ownership.test, snowflake_grant_account_role.test]
#   provider   = snowflake.secondary
#   database   = snowflake_database.test.name
#   name      = "schema"
# }

# Snowflake Security Intergration it is not supported by Terraform under current version; this object is going to be managed by the Policy Manager

# -- Snowflake oauth Integration -- #

# # Internal

# resource "snowflake_oauth_integration" "tableau_desktop" {
#   name                         = "TABLEAU_DESKTOP" # *required*
#   oauth_client                 = "TABLEAU_DESKTOP" # *required*
#   enabled                      = true # Accepted values true | false
#   oauth_issue_refresh_tokens   = true # Accepted values true | false
#   oauth_refresh_token_validity = 3600 # This number is in seconds
#   blocked_roles_list           = ["SYSADMIN"] # List of roles that a user cannot explicitly consent to using after authenticating. 
#   # Do not include ACCOUNTADMIN, ORGADMIN or SECURITYADMIN as they are already implicitly enforced and will cause in-place updates
# }

# # External

# resource "snowflake_external_oauth_integration" "azure" {
#   name                             = "AZURE_POWERBI" # *required*
#   type                             = "AZURE" # *required*
#   enabled                          = true # *required* ~ Accepted values true | false
#   issuer                           = "https://sts.windows.net/00000000-0000-0000-0000-000000000000" # *required*
#   snowflake_user_mapping_attribute = "LOGIN_NAME" # *required*
#   jws_keys_urls                    = ["https://login.windows.net/common/discovery/keys"]
#   audience_urls                    = ["https://analysis.windows.net/powerbi/connector/Snowflake"]
#   token_user_mapping_claims        = ["upn"] # *required*
# }



# SHARE

# resource "snowflake_database" "from_share" {
#   name    = "snowflake_database_from_share" # *required*
#   comment = "This database will be used for "
#   from_share = {
#     provider = snowflake.shareadmin # It depends on the share provider 
#     share = "share_name" # The name of the share
#   }
# }
