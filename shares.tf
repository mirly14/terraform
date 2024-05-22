# -- Share -- #

# Remember to define dependency between objects on a share, because shared objects have to be dropped before dropping share

resource "snowflake_share" "test_share" {
  provider = snowflake.accountadmin 
  name     = "dummy_share" # *required*
  comment  = "top secret"
  accounts = ["HQAMIPM.MKB76277"] # A list of accounts to be added to the share. Values should not be the account locator. First goes the account organization number, then the account name number. 
}

resource "snowflake_grant_privileges_to_share" "example" {
  provider = snowflake.accountadmin
  to_share    = snowflake_share.test_share.name # *required*
  privileges  = ["USAGE"] # *required* ~ Accepted values REFERENCE_USAGE | EVOLVE_SCHEMA | SELECT | READ
  on_database = snowflake_database.simple.name # on_database can be changed for on_schema or on_table
}
