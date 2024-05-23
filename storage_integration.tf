# -- Storage Integration Management -- #

# If you want to see how to use variables, please refer to the account_management.tf file

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
