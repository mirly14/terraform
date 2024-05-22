##
#snowflake_user
/* resource "snowflake_user" "create_user" {
  name         = var.snowflake_user
  login_name   = var.login_name
  comment      = "A user of snowflake."
  password     = var.password
  disabled     = false
  display_name = "Snowflake User"
  email        = "user@snowflake.example"
  first_name   = "Snowflake"
  last_name    = "User"

  default_warehouse       = "warehouse"
  default_secondary_roles = ["ALL"]
  default_role            = "role1"

  rsa_public_key   = "..."
  rsa_public_key_2 = "..."

  must_change_password = false
}
 */
# snowflake_user_grant
# snowflake_user_ownership_grant
# snowflake_user_password_policy_attachment
# snowflake_user_public_keys


##
#snowflake_role
/* resource "snowflake_role" "create_role" {
  name    = "var.role"
  comment = "A role."
} */
# snowflake_role_grants
# snowflake_role_ownership_grant
# snowflake_row_access_policy
# snowflake_row_access_policy_grant




##
#snowflake tag
/* resource "snowflake_database" "database" {
  name = var.databases
}

resource "snowflake_schema" "schema" {
  name     = var.schema
  database = snowflake_database.database.name
}

resource "snowflake_tag" "tag" {
  name           = var.tag_name
  database       = snowflake_database.database.name
  schema         = snowflake_schema.schema.name
  allowed_values = var.tag_accepted_values
} */

# snowflake_tag_association
# snowflake_tag_grant
# snowflake_tag_masking_policy_association









# grant account role to account role

# resource "snowflake_role" "role" {
#   name = var.role_name
# }

# resource "snowflake_grant_account_role" "g" {
#   role_name        = snowflake_role.role.name
    
# }

# # grant account role to user

# resource "snowflake_role" "role" {
#   name = var.role_name
# }

# resource "snowflake_user" "user" {
#   name = var.user_name
# }

# resource "snowflake_grant_account_role" "g" {
#   role_name = snowflake_role.role.name
#   user_name = snowflake_user.user.name
# }

# ##
# #grant database role to account role

# resource "snowflake_database_role" "database_role" {
#   database = var.database
#   name     = var.database_role_name
# }

# resource "snowflake_role" "parent_role" {
#   name = var.parent_role_name
# }

# resource "snowflake_grant_database_role" "g" {
#   database_role_name = "\"${var.database}\".\"${snowflake_database_role.database_role.name}\""
#   parent_role_name   = snowflake_role.parent_role.name
# }

# # grant database role to database role


# resource "snowflake_database_role" "database_role" {
#   database = var.database
#   name     = var.database_role_name
# }

# resource "snowflake_database_role" "parent_database_role" {
#   database = var.database
#   name     = var.parent_database_role_name
# }

# resource "snowflake_grant_database_role" "g" {
#   database_role_name        = "\"${var.database}\".\"${snowflake_database_role.database_role.name}\""
#   parent_database_role_name = "\"${var.database}\".\"${snowflake_database_role.parent_database_role.name}\""
# }

# # grant database role to share

# resource "snowflake_grant_database_role" "g" {
#   database_role_name = "\"${var.database}\".\"${snowflake_database_role.database_role.name}\""
#   share_name         = snowflake_share.share.name
# }

##
#snowflake_grant_ownership

##
#snowflake_grant_privileges_to_account_role

##
#snowflake_grant_privileges_to_database_role

##
#snowflake_grant_privileges_to_role

##
#snowflake_grant_privileges_to_share

##



##


#snowflake tag
/* resource "snowflake_database" "database" {
  name = "database"
}

resource "snowflake_schema" "security_schema" {
  name     = "schema"
  database = snowflake_database.database.name
}

resource "snowflake_tag" "tag" {
  name           = "var.tag_name"
  database       = snowflake_database.database.name
  schema         = snowflake_schema.schema.name
  allowed_values = ["finance", "engineering"]
} */
