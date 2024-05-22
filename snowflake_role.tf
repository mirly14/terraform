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
