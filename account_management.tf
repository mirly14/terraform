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
