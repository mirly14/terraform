# -- Providers -- #

# Here goes the credentials to connect to your Snowflake account
# It is a best practice to write any name with capitalize letters (e.g. user name, schema name, and so on)

provider "snowflake" {
  user = "USER_ACCOUNT" # *required*
  password = "Abc12345"  # *required*
  account  = "EQB69117" # *required* ~ This is the account locator number in Snowflake
  role = "SYSADMIN"
  region = "us-east-1" # Only necessary for this element
}

provider "snowflake" {
  alias = "orgadmin"
  user = "USER_ACCOUNT" # *required*
  password = "Abc12345" # *required*
  account  = "EQB69117" # *required* 
  role = "ORGADMIN"
  region = "us-east-1" 
}

provider "snowflake" {
  alias = "accountadmin" # You can specify an alias for each to differentiate (securityadmin | sysadmin | public | custom_roles )
  user = "USER_ACCOUNT" # *required*
  password = "Abc12345"  # *required*
  account  = "EQB69117" # *required*
  role = "ACCOUNTADMIN"
  region = "us-east-1"
}  
