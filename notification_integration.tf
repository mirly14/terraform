# -- Notification Integration Management -- #

# If you want to see how to use variables, please refer to the account_management.tf file

resource "snowflake_notification_integration" "integration" {
  name    = "notification" # *required*
  comment = "A notification integration"
  enabled   = true # Accepted values true | false
  
  # AWS_SQS
  notification_provider = "AWS_SQS" # *required* ~ Accepted values AZURE_STORAGE_QUEUE | AWS_SNS | GCP_PUBSUB
  aws_sqs_arn           = "..." */ # AWS SQS queue ARN for notification integration to connect to
  
  # AZURE_STORAGE_QUEUE
  # notification_provider           = "AZURE_STORAGE_QUEUE" 
  # azure_storage_queue_primary_uri = "..."
  # azure_tenant_id                 = "..."

  # AWS_SNS
  # notification_provider = "AWS_SNS"
  # aws_sns_topic_arn     = "..."
}

#--Argument used to specify explicit dependencies between resources
#  depends_on = [
#     snowflake_notification_integration.integration  #name of the resource
#   ]
# } 

# This section allows you to print specific code from your resource in the console

# output "copy_statement_pipe" {
#   value = snowflake_pipe.pipe.copy_statement # Add the resource you want to see
# }
