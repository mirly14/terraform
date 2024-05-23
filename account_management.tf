# -- Account Management -- # 

# ORGADMIN priviliges are required for this resource, only for creating the account for the admin. 

#This is an example of how you can set up a resource usign variables. 

resource "snowflake_account" "beta_account" { 
  provider = snowflake.orgadmin # It depends on the provider you created
  name                 = var.account_name # *required* ~ Only capital letters, numbers and underscores
  admin_name           = var.account_admin_name # *required*
  admin_password       = var.account_admin_password
  email                = var.account_email # *required*
  must_change_password = true # Accepted values true | false ~ Every new account is forced to change password the fisrt time they sign in
  edition              = var.account_edition # *required* ~ Accepted values STANDARD | ENTERPRISE | BUSINESS_CRITICAL
  comment              = var.account_comment
} 

resource "snowflake_grant_privileges_to_account_role" "example_account" {
  provider = snowflake.accountadmin
  privileges        = ["CREATE DATABASE", "CREATE USER"] # It could be any of the Snowflake Global Privileges ~ ["CREATE USER"]
  account_role_name = "ACCOUNTADMIN" # *required* ~ This is the name of the role you want to grant privileges 
  on_account        = true # Accepted values true | false ~ If true, the privileges will be granted on the account
}
