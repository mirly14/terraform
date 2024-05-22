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
