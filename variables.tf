#-- This is an example in how you can define variables--#


# Define variables for providers.tf

variable "snowflake_account_name" {
  description = "Snowflake Account"
  type        = string
  default     = "opb30669"
}

variable "snowflake_username" {
  description = "Snowflake Username"
  type        = string
  default     = "beta"
}

variable "snowflake_password" {
  description = "Snowflake Password"
  type        = string
  default     = "Beta123456"
}

variable "snowflake_region" {
   description = "Snowflake Region"
   type = string
   default = "us-east-1"
}

# Define variables for Account Management

variable "account_name" {
  description = "Identifier for the account"
  type        = string
  default     = "test_account"
}

variable "account_admin_name" {
  description = "Login name of the initial administrative user of the account"
  type        = string
  default     = "Jonathan"
}

variable "account_admin_password" {
  description = "Password for the initial administrative user of the account."
  type        = string
  default     = "Beta123456"
}

variable "account_email" {
  description = "Email address of the initial administrative user of the account."
  type        = string
  default     = "alonso.sanchez200012@gmail.com"
}

variable "account_must_change_password" {
  description = "Specifies whether the new user created is forced to change the password"
  type        = bool
  default     = false
}

variable "account_region" {
   description = "Snowflake Region where the account is created"
   type = string
   default = "us-east-1"
} 

variable "account_edition" {
   description = "Snowflake Edition of the account"
   type = string
   default = "ENTERPRISE"
} 


variable "account_comment" {
   description = "Specifies a comment for the account"
   type = string
   default = "test account for terraform"
} 


variable "account_roles" {
   description = "Grants privilege to these roles"
   type = set(string)
   default = ["SYSADMIN", "ACCOUNTADMIN"]
} 

variable "account_privilege" {
   description = "The account privilege to grant"
   type = string
   default = "CREATE ROLE"
} 

variable "account_with_grant_option" {
   description = "When this is set to true, allows the recipient role to grant the privileges to other roles."
   type = bool
   default = false
} 

variable "account_parameter_key" {
   description = "Name of account parameter."
   type = string
   default = "ALLOW_ID_TOKEN" 
} 

variable "account_parameter_value" {
   description = "Value of the account parameter."
   type = string
   default = "false" 
} 

variable "account_password_policy_database" {
   description = "database where the password policy is"
   type = string
   default = "test_db" 
} 

variable "account_password_policy_schema" {
   description = "Name of the schema where the password policy is"
   type = string
   default = "snowflake_password_policy.default.qualified_name" 
} 

variable "account_password_policy_name" {
   description = "Name of the password policy"
   type = string
   default = "default_policy" 
} 

variable "managed_account_name" {
  description = "Identifier for the managed account, unique for account"
  type        = string
  default     = "test_account"
}

variable "managed_account_admin_name" {
  description = "Login name of the initial user of the account"
  type        = string
  default     = "Jonathan"
}

variable "managed_account_admin_password" {
  description = "Password for the initial user of the account."
  type        = string
  default     = "Beta123456"
}

variable "managed_account_comment" {
  description = "Comment for the managed account."
  type        = string
  default     = "Test managed account"
}


variable "managed_account_type" {
  description = "Type of the managed account."
  type        = string
  default     = "READER"
}




# Define variables for different types of Database 

# --- SIMPLE ---

variable "snowflake_name_database" {
  description = "Snowflake Database Name"
  type        = string
  default     = "db_simple"
}

variable "database_data_retention_time_in_days" {
  description = "Snowflake Database Retention Days"
  type = number
  default = 3
}

# --- WITH REPLICATION ---

variable "snowflake_name_database_with_replication" {
  description = "Snowflake Database Name"
  type        = string
  default     = "db_with_replication"
}

variable "replication_configuration" {
  description = "Database Replication Configuration"
  type = list(string)
  default = ["account1", "account2"]
}

variable "ignore_edition_check" {
  type = bool
  default = true */
}

# --- FROM REPLICA ---

variable "snowflake_name_database_from_replication" {
  description = "Snowflake Database From Replication Name"
  type = string
  default = "db_with_replication"
}

variable "from_replica_path" {
  type = string
  default = "\"org1\".\"account1\".\"primary_db_name\""

} 

variable "snowflake_database_from_share" {
  type = string
  default = "db_from_share"
}

variable "from_share" {
  type = object({
    provider = string
    share = string
  })
}

# Define variables for SCHEMAS

variable "snowflake_schema" {
  type = string
  default = "my_schema"
}

variable "schema_data_retention_time_in_days" {
  description = "Snowflake Schema Retention Days"
  type = number
  default = 1
}

# Define variables for WAREHOUSE

variable "warehouse_name" {
  type = string
  default = "test_wh"
}

# Define variables for TABLES

variable "table_name" {
  type = string
  default = "my_table"
 }

# Define variables for Security and Permissions

#--- FROM USER ---
variable "snowflake_user" {
   description = "Name of the new user"
   type = string
   default = "test_user"
}
variable "login_name" {
   description = "Longin name"
   type = string
   default = "login_name"
}

variable "password" {
   description = "Password"
   type = string
   default = "password_1234"
}

#tags
variable "tag_name" {
   description = "Name of the tag"
   type = string
   default = "test tag"
}

variable "tag_accepted_values" {
  description = "Tag acepted values"
  type = list(string)
  default = ["value1", "value2"]
}

#grants
variable "role_name" {
   description = "Role to grant permissions"
   type = string
   default = "Public"
}

variable "user_name" {
   description = "Grant account role to user"
   type = string
   default = "beta_developer"
}

variable "database" {
   description = "Database to grant permissions"
   type = string
   default = "beta_developer"
}
variable "database_role_name" {
   description = "Database role which will be granted to share or parent role"
   type = string
   default = "beta_developer"
}
variable "parent_role_name" {
   description = "Parent account role which will create a parent-child relationship between the roles."
   type = string
   default = "beta_developer"
}

variable "parent_database_role_name" {
   description = "Parent database role which will create a parent-child relationship between the roles."
   type = string
   default = "beta_developer"
}

variable "role" {
   description = "Name of the rol that needs to be created"
   type = string
   default = "beta_developer"
}
