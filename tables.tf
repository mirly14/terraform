# TABLES

/* resource "snowflake_schema" "schema" {
  database = var.snowflake_name_database_with_replication
  name = var.snowflake_schema
  comment = "My schema"

  is_transient        = false
  is_managed          = false
  data_retention_days = var.schema_data_retention_time_in_days
}

resource "snowflake_sequence" "sequence" {
  database = snowflake_schema.schema.database
  schema   = snowflake_schema.schema.name
  name     = "sequence"
}

resource "snowflake_table" "table" {
  database                    = snowflake_schema.schema.database
  schema                      = snowflake_schema.schema.name
  name                        = var.table_name
  comment                     = "My table"
  cluster_by                  = ["to_date(DATE)"]
  data_retention_time_in_days = snowflake_schema.schema.data_retention_time_in_days
  change_tracking             = false

  column {
    name     = "id"
    type     = "int"
    nullable = true

    default {
      sequence = snowflake_sequence.sequence.fully_qualified_name
    }
  }

  column {
    name     = "identity"
    type     = "NUMBER(38,0)"
    nullable = true

    identity {
      start_num = 1
      step_num  = 3
    }
  }

  column {
    name     = "data"
    type     = "text"
    nullable = false
    collate  = "en-ci"
  }

  column {
    name = "DATE"
    type = "TIMESTAMP_NTZ(9)"
  }

  column {
    name    = "extra"
    type    = "VARIANT"
    comment = "extra data"
  }

  primary_key {
    name = "my_key"
    keys = ["data"]
  }
}

resource "snowflake_table_constraint" "primary_key" {
  name     = "my_primary_key"
  type     = "PRIMARY KEY"
  table_id = snowflake_table.table.qualified_name # qualified_name
  columns  = ["col1"]
  comment  = "My first Primary Key"
}

resource "snowflake_table_constraint" "unique" {
  name     = "unique"
  type     = "UNIQUE"
  table_id = snowflake_table.table.qualified_name # qualified_name
  columns  = ["col3"]
  comment  = "My first Unique Column"
}

# FOREIGN KEYS

resource "snowflake_table" "fk_t" {
  database = snowflake_schema.schema.database
  schema = snowflake_schema.schema.name
  name = var.table_name

  column {
    name     = "fk_col1"
    type     = "text"
    nullable = false
  }

  column {
    name     = "fk_col2"
    type     = "text"
    nullable = false
  }
}

resource "snowflake_table_constraint" "foreign_key" {
  name     = "myconstraintfk"
  type     = "FOREIGN KEY"
  table_id = snowflake_table.table.qualified_name # qualified name
  columns  = ["col2"]
  foreign_key_properties {
    references {
      table_id = snowflake_table.fk_t.qualified_name # qualified name
      columns  = ["fk_col1"]
    }
  }
  enforced   = false
  deferrable = false
  initially  = "IMMEDIATE"
  comment    = "My first foreign key"
} */