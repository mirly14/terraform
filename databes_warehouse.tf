
# Databases

/* resource "snowflake_database" "normal" {
  name = var.snowflake_name_database
  comment = "This database will be used for "
  data_retention_time_in_days = var.database_data_retention_time_in_days
} */

/* resource "snowflake_database" "with_replication" {
  name = var.snowflake_name_database_with_replication
  comment = "This database will be used for "
  replication_configuration {
    accounts = var.replication_configuration.aacounts
    ignore_edition_check = var.ignore_edition_check
  }
} */

/* resource "snowflake_database" "from_replica" {
  name = var.snowflake_name_database_from_replication
  comment = "This database will be used for "
  data_retention_time_in_days = var.database_data_retention_time_in_days
  from_replica = var.from_replica_path
}
 */

/* resource "snowflake_database" "from_share" {
  name    = var.snowflake_database_from_share
  comment = "This database will be used for "
  from_share = {
    provider = var.from_share.provider
    share = var.from_share.share
  }
} */

# SCHEMAS

/* resource "snowflake_schema" "warehouse_schema" {
  database = var.snowflake_name_database_with_replication
  name = var.snowflake_schema
  comment = "My schema"

  is_transient        = false
  is_managed          = false
  data_retention_days = var.schema_data_retention_time_in_days
}
 */

# resource "snowflake_schema" "schema_prod_dataintelligence" {
#   provider = snowflake.dbtadmin
#   database = snowflake_database.dbt_database.name
#   name     = "NC_PROD_DATAINTELLIGENCE"

#   is_transient        = false
#   is_managed          = false
#   data_retention_days = 1
# }


# WAREHOUSE 
/* 
resource "snowflake_warehouse" "warehouse" {
  name           = var.warehouse_name
  comment        = "The size of the WH can be changed"
  warehouse_size = "small"
  
  initially_suspended = true
  auto_resume = true
  auto_suspend = 120
}

resource "snowflake_warehouse_grant" "grant" {
  warehouse_name = "warehouse"
  privilege      = "MODIFY"

  roles = ["role1", "role2"]

  with_grant_option = false
}
 */
