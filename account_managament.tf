/* resource "snowflake_account" "account_1" {
  name                 = var.account_name
  admin_name           = var.account_admin_name
  admin_password       = var.account_admin_password
  email                = var.account_email
  must_change_password = var.account_must_change_password
  edition              = var.account_edition
  comment              = var.account_comment
  region               = var.account_region
} 

resource "snowflake_account_grant" "grant" {
  roles             = var.account_roles
  privilege         = var.account_privilege
  with_grant_option = var.account_with_grant_option
} */

/* resource "snowflake_account_parameter" "p" {
  key   = var.account_parameter_key
  value = var.account_parameter_value
} */

/* resource "snowflake_password_policy" "default" {
  database = var.account_password_policy_database
  schema   = var.account_password_policy_schema
  name     = var.account_password_policy_name
}

resource "snowflake_account_password_policy_attachment" "attachment" {
  password_policy = snowflake_password_policy.default.qualified_name
}


resource "snowflake_managed_account" "account" {
  name           = var.managed_account_name
  admin_name     = var.managed_account_admin_name
  admin_password = var.managed_account_admin_password
  type           = var.managed_account_type
  comment        = var.managed_account_comment
}

 */
