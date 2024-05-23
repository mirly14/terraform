# -- Grant Ownership -- #

# For RBAC 

# resource snowflake_role TEST_DB_TEST_SCHEMA_R_AR {
#   name = "TEST_DB_TEST_SCHEMA_R_AR"
# }

# resource snowflake_role_ownership_grant role_test_db_test_schema_r_ar_ownership_grant {
#   on_role_name = snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name
#   to_role_name = "USERADMIN"
#   revert_ownership_to_role_name = "SYSADMIN"
# }

# resource snowflake_role TEST_DB_TEST_SCHEMA_RW_AR {
#   name = "TEST_DB_TEST_SCHEMA_RW_AR"
# }

# resource snowflake_role_ownership_grant role_test_db_test_schema_rw_ar_ownership_grant {
#   on_role_name = snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name
#   to_role_name = "USERADMIN"
#   revert_ownership_to_role_name = "SYSADMIN"
# }

# resource snowflake_role TEST_DB_TEST_SCHEMA_FULL_AR {
#   name = "TEST_DB_TEST_SCHEMA_FULL_AR"
# }

# resource snowflake_role_ownership_grant role_test_db_test_schema_full_ar_ownership_grant {
#   on_role_name = snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name
#   to_role_name = "USERADMIN"
#   revert_ownership_to_role_name = "SYSADMIN"
# }

# resource snowflake_role TEST_WH_U_AR {
#   name = "TEST_WH_U_AR"
# }

# resource snowflake_role_ownership_grant role_test_wh_u_ar_ownership_grant {
#   on_role_name = snowflake_role.TEST_WH_U_AR.name
#   to_role_name = "USERADMIN"
#   revert_ownership_to_role_name = "SYSADMIN"
# }

# resource snowflake_role TEST_WH_UM_AR {
#   name = "TEST_WH_UM_AR"
# }

# resource snowflake_role_ownership_grant role_test_wh_um_ar_ownership_grant {
#   on_role_name = snowflake_role.TEST_WH_UM_AR.name
#   to_role_name = "USERADMIN"
#   revert_ownership_to_role_name = "SYSADMIN"
# }

# resource snowflake_role TEST_WH_FULL_AR {
#   name = "TEST_WH_FULL_AR"
# }

# resource snowflake_role_ownership_grant role_test_wh_full_ar_ownership_grant {
#   on_role_name = snowflake_role.TEST_WH_FULL_AR.name
#   to_role_name = "USERADMIN"
#   revert_ownership_to_role_name = "SYSADMIN"
# }

# resource snowflake_database_grant grant_usage_on_test_db_database {
#   database_name = snowflake_database.TEST_DB.name
#   privilege = "USAGE"
#   roles = ["TEST_DB_TEST_SCHEMA_R_AR", "TEST_DB_TEST_SCHEMA_RW_AR", "TEST_DB_TEST_SCHEMA_FULL_AR", "TEST_DB_TEST_SCHEMA_FULL_AR"]

#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant]
# }

# resource snowflake_schema_grant grant_usage_on_test_db__test_schema_schema {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   depends_on = [snowflake_role_grants.role_test_db_test_schema_r_ar_grants, snowflake_role_grants.role_test_db_test_schema_rw_ar_grants, snowflake_role_grants.role_test_db_test_schema_full_ar_grants, snowflake_role_grants.role_test_db_test_schema_full_ar_grants, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant]

#   with_grant_option = false
#   enable_multiple_grants = true
# }

# resource snowflake_schema_grant grant_ownership_on_test_db__test_schema_schema {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   depends_on = [snowflake_role_grants.role_test_db_test_schema_full_ar_grants, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]

#   with_grant_option = false
#   enable_multiple_grants = true
# }

# resource snowflake_table_grant grant_select_on_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "SELECT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_select_on_future_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "SELECT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_insert_on_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "INSERT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_update_on_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "UPDATE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_delete_on_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "DELETE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_references_on_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "REFERENCES"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_insert_on_future_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "INSERT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_update_on_future_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "UPDATE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_delete_on_future_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "DELETE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_references_on_future_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "REFERENCES"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_table_grant grant_ownership_on_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_table_grant grant_ownership_on_future_test_db__test_schema_tables {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_table_grant.grant_ownership_on_test_db__test_schema_tables]
# }

# resource snowflake_view_grant grant_select_on_test_db__test_schema_views {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "SELECT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_view_grant.grant_ownership_on_test_db__test_schema_views]
# }

# resource snowflake_view_grant grant_select_on_future_test_db__test_schema_views {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "SELECT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_view_grant.grant_ownership_on_test_db__test_schema_views]
# }

# resource snowflake_view_grant grant_ownership_on_test_db__test_schema_views {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_view_grant grant_ownership_on_future_test_db__test_schema_views {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_view_grant.grant_ownership_on_test_db__test_schema_views]
# }

# resource snowflake_sequence_grant grant_usage_on_test_db__test_schema_sequences {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_sequence_grant.grant_ownership_on_test_db__test_schema_sequences]
# }

# resource snowflake_sequence_grant grant_usage_on_future_test_db__test_schema_sequences {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_sequence_grant.grant_ownership_on_test_db__test_schema_sequences]
# }

# resource snowflake_sequence_grant grant_ownership_on_test_db__test_schema_sequences {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_sequence_grant grant_ownership_on_future_test_db__test_schema_sequences {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_sequence_grant.grant_ownership_on_test_db__test_schema_sequences]
# }

# resource snowflake_stage_grant grant_usage_on_test_db__test_schema_stages {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_stage_grant.grant_ownership_on_test_db__test_schema_stages]
# }

# resource snowflake_stage_grant grant_read_on_test_db__test_schema_stages {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "READ"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_stage_grant.grant_ownership_on_test_db__test_schema_stages]
# }

# resource snowflake_stage_grant grant_usage_on_future_test_db__test_schema_stages {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_stage_grant.grant_ownership_on_test_db__test_schema_stages]
# }

# resource snowflake_stage_grant grant_read_on_future_test_db__test_schema_stages {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "READ"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_stage_grant.grant_ownership_on_test_db__test_schema_stages]
# }

# resource snowflake_stage_grant grant_write_on_future_test_db__test_schema_stages {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "WRITE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_stage_grant.grant_usage_on_future_test_db__test_schema_stages, snowflake_stage_grant.grant_read_on_future_test_db__test_schema_stages, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_stage_grant.grant_ownership_on_test_db__test_schema_stages]
# }

# resource snowflake_stage_grant grant_write_on_test_db__test_schema_stages {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "WRITE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_stage_grant.grant_ownership_on_test_db__test_schema_stages]
# }

# resource snowflake_stage_grant grant_ownership_on_test_db__test_schema_stages {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_stage_grant grant_ownership_on_future_test_db__test_schema_stages {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_stage_grant.grant_ownership_on_test_db__test_schema_stages]
# }

# resource snowflake_file_format_grant grant_usage_on_test_db__test_schema_file_formats {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_file_format_grant.grant_ownership_on_test_db__test_schema_file_formats]
# }

# resource snowflake_file_format_grant grant_usage_on_future_test_db__test_schema_file_formats {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_file_format_grant.grant_ownership_on_test_db__test_schema_file_formats]
# }

# resource snowflake_file_format_grant grant_ownership_on_test_db__test_schema_file_formats {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_file_format_grant grant_ownership_on_future_test_db__test_schema_file_formats {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_file_format_grant.grant_ownership_on_test_db__test_schema_file_formats]
# }

# resource snowflake_stream_grant grant_select_on_test_db__test_schema_streams {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "SELECT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_stream_grant.grant_ownership_on_test_db__test_schema_streams]
# }

# resource snowflake_stream_grant grant_select_on_future_test_db__test_schema_streams {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "SELECT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_stream_grant.grant_ownership_on_test_db__test_schema_streams]
# }

# resource snowflake_stream_grant grant_ownership_on_test_db__test_schema_streams {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_stream_grant grant_ownership_on_future_test_db__test_schema_streams {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_stream_grant.grant_ownership_on_test_db__test_schema_streams]
# }

# resource snowflake_procedure_grant grant_usage_on_test_db__test_schema_procedures {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_procedure_grant.grant_ownership_on_test_db__test_schema_procedures]
# }

# resource snowflake_procedure_grant grant_usage_on_future_test_db__test_schema_procedures {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_procedure_grant.grant_ownership_on_test_db__test_schema_procedures]
# }

# resource snowflake_procedure_grant grant_ownership_on_test_db__test_schema_procedures {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_procedure_grant grant_ownership_on_future_test_db__test_schema_procedures {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_procedure_grant.grant_ownership_on_test_db__test_schema_procedures]
# }

# resource snowflake_function_grant grant_usage_on_test_db__test_schema_functions {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_function_grant.grant_ownership_on_test_db__test_schema_functions]
# }

# resource snowflake_function_grant grant_usage_on_future_test_db__test_schema_functions {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "USAGE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_function_grant.grant_ownership_on_test_db__test_schema_functions]
# }

# resource snowflake_function_grant grant_ownership_on_test_db__test_schema_functions {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_function_grant grant_ownership_on_future_test_db__test_schema_functions {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_function_grant.grant_ownership_on_test_db__test_schema_functions]
# }

# resource snowflake_materialized_view_grant grant_select_on_test_db__test_schema_materialized_views {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "SELECT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_materialized_view_grant.grant_ownership_on_test_db__test_schema_materialized_views]
# }

# resource snowflake_materialized_view_grant grant_select_on_future_test_db__test_schema_materialized_views {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "SELECT"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_r_ar_ownership_grant, snowflake_materialized_view_grant.grant_ownership_on_test_db__test_schema_materialized_views]
# }

# resource snowflake_materialized_view_grant grant_ownership_on_test_db__test_schema_materialized_views {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_materialized_view_grant grant_ownership_on_future_test_db__test_schema_materialized_views {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_materialized_view_grant.grant_ownership_on_test_db__test_schema_materialized_views]
# }

# resource snowflake_task_grant grant_monitor_on_test_db__test_schema_tasks {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "MONITOR"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_task_grant.grant_ownership_on_test_db__test_schema_tasks]
# }

# resource snowflake_task_grant grant_operate_on_test_db__test_schema_tasks {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OPERATE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_task_grant.grant_ownership_on_test_db__test_schema_tasks]
# }

# resource snowflake_task_grant grant_monitor_on_future_test_db__test_schema_tasks {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "MONITOR"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_task_grant.grant_ownership_on_test_db__test_schema_tasks]
# }

# resource snowflake_task_grant grant_operate_on_future_test_db__test_schema_tasks {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OPERATE"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name, snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_rw_ar_ownership_grant, snowflake_task_grant.grant_ownership_on_test_db__test_schema_tasks]
# }

# resource snowflake_task_grant grant_ownership_on_test_db__test_schema_tasks {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name
#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]
#   enable_multiple_grants = true
#   on_all = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant]
# }

# resource snowflake_task_grant grant_ownership_on_future_test_db__test_schema_tasks {
#   database_name = snowflake_database.TEST_DB.name
#   schema_name = snowflake_schema.TEST_DB__TEST_SCHEMA.name

#   privilege = "OWNERSHIP"
#   roles = [snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name]

#   on_future = true
#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_schema_grant.grant_ownership_on_test_db__test_schema_schema, snowflake_role_ownership_grant.role_test_db_test_schema_full_ar_ownership_grant, snowflake_task_grant.grant_ownership_on_test_db__test_schema_tasks]
# }

# resource snowflake_warehouse_grant grant_usage_on_warehouse_test_wh {
#   warehouse_name = snowflake_warehouse.TEST_WH.name
#   privilege = "USAGE"

#   roles = [snowflake_role.TEST_WH_U_AR.name, snowflake_role.TEST_WH_UM_AR.name]

#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_role_ownership_grant.role_test_wh_u_ar_ownership_grant]
# }

# resource snowflake_warehouse_grant grant_monitor_on_warehouse_test_wh {
#   warehouse_name = snowflake_warehouse.TEST_WH.name
#   privilege = "MONITOR"

#   roles = [snowflake_role.TEST_WH_UM_AR.name]

#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_role_ownership_grant.role_test_wh_um_ar_ownership_grant]
# }

# resource snowflake_warehouse_grant grant_ownership_on_warehouse_test_wh {
#   warehouse_name = snowflake_warehouse.TEST_WH.name
#   privilege = "OWNERSHIP"

#   roles = [snowflake_role.TEST_WH_FULL_AR.name]

#   with_grant_option = false
#   enable_multiple_grants = true
#   depends_on = [snowflake_role_ownership_grant.role_test_wh_full_ar_ownership_grant]
# }

# resource snowflake_role_grants role_test_db_test_schema_r_ar_grants {
#   role_name = snowflake_role.TEST_DB_TEST_SCHEMA_R_AR.name

#   enable_multiple_grants = true
#   roles = [
#     "SYSADMIN",
#   ]
# }

# resource snowflake_role_grants role_test_db_test_schema_rw_ar_grants {
#   role_name = snowflake_role.TEST_DB_TEST_SCHEMA_RW_AR.name

#   enable_multiple_grants = true
#   roles = [
#     "SYSADMIN",
#   ]
# }

# resource snowflake_role_grants role_test_db_test_schema_full_ar_grants {
#   role_name = snowflake_role.TEST_DB_TEST_SCHEMA_FULL_AR.name

#   enable_multiple_grants = true
#   roles = [
#     "SYSADMIN",
#     snowflake_role.BETA_DEVELOPER.name,
#   ]
# }

# resource snowflake_role_grants role_test_wh_u_ar_grants {
#   role_name = snowflake_role.TEST_WH_U_AR.name

#   enable_multiple_grants = true
#   roles = [
#     "SYSADMIN",
#     snowflake_role.BETA_DEVELOPER.name,
#   ]
# }

# resource snowflake_role_grants role_test_wh_um_ar_grants {
#   role_name = snowflake_role.TEST_WH_UM_AR.name

#   enable_multiple_grants = true
#   roles = [
#     "SYSADMIN",
#   ]
# }

# resource snowflake_role_grants role_test_wh_full_ar_grants {
#   role_name = snowflake_role.TEST_WH_FULL_AR.name

#   enable_multiple_grants = true
#   roles = [
#     "SYSADMIN",
#   ]
# }

# resource "snowflake_role" "test" {
#   name = "role"
# }

# resource "snowflake_database" "test" {
#   name = "database"
# }

# resource "snowflake_grant_ownership" "test" {
#   account_role_name = snowflake_role.test.name
#   on {
#     object_type = "DATABASE"
#     object_name = snowflake_database.test.name
#   }
# }

# resource "snowflake_grant_account_role" "test" {
#   role_name = snowflake_role.test.name
#   user_name = "username"
# }

# provider "snowflake" {
#   profile = "default"
#   alias   = "secondary"
#   role    = snowflake_role.test.name
# }
 
# With ownership on the database, the secondary provider is able to create schema on it without any additional privileges

# resource "snowflake_schema" "test" {
#   depends_on = [snowflake_grant_ownership.test, snowflake_grant_account_role.test]
#   provider   = snowflake.secondary
#   database   = snowflake_database.test.name
#   name      = "schema"
# }

# Snowflake Security Intergration it is not supported by Terraform under current version; this object is going to be managed by the Policy Manager

# -- Snowflake oauth Integration -- #

# # Internal

# resource "snowflake_oauth_integration" "tableau_desktop" {
#   name                         = "TABLEAU_DESKTOP" # *required*
#   oauth_client                 = "TABLEAU_DESKTOP" # *required*
#   enabled                      = true # Accepted values true | false
#   oauth_issue_refresh_tokens   = true # Accepted values true | false
#   oauth_refresh_token_validity = 3600 # This number is in seconds
#   blocked_roles_list           = ["SYSADMIN"] # List of roles that a user cannot explicitly consent to using after authenticating. 
#   # Do not include ACCOUNTADMIN, ORGADMIN or SECURITYADMIN as they are already implicitly enforced and will cause in-place updates
# }

# # External

# resource "snowflake_external_oauth_integration" "azure" {
#   name                             = "AZURE_POWERBI" # *required*
#   type                             = "AZURE" # *required*
#   enabled                          = true # *required* ~ Accepted values true | false
#   issuer                           = "https://sts.windows.net/00000000-0000-0000-0000-000000000000" # *required*
#   snowflake_user_mapping_attribute = "LOGIN_NAME" # *required*
#   jws_keys_urls                    = ["https://login.windows.net/common/discovery/keys"]
#   audience_urls                    = ["https://analysis.windows.net/powerbi/connector/Snowflake"]
#   token_user_mapping_claims        = ["upn"] # *required*
# }



# SHARE

# resource "snowflake_database" "from_share" {
#   name    = "snowflake_database_from_share" # *required*
#   comment = "This database will be used for "
#   from_share = {
#     provider = snowflake.shareadmin # It depends on the share provider 
#     share = "share_name" # The name of the share
#   }
# }
