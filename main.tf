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

