
resource "google_bigquery_dataset" "dataset" {
    dataset_id                  = "jelambrar96_zoomcamp_20240331_ghdataset"
    friendly_name               = "ghdataset"
    description                 = ""
    location                    = "${var.region}"

    # default_encryption_configuration {
    #     kms_key_name = google_kms_crypto_key.crypto_key.id
    # }
}

# resource "google_kms_crypto_key" "crypto_key" {
#     name     = "google_kms_crypto_key"
#     key_ring = google_kms_key_ring.key_ring.id
# }
# 
# resource "google_kms_key_ring" "key_ring" {
#     name     = "google_kms_key_ring"
#     location = "us"
# }

# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_action_type" {
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id = "look_up_action_type"
    deletion_protection = false
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucket_tables}/${google_storage_bucket_object.look_up_action_type_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_action_type_object]
}

resource "google_storage_bucket_object" "look_up_action_type_object" {
    name         = "lk_tables/look_up_action_type_object.csv"
    content_type = "csv"
    source       = "../bigquery/tables/look_up_action_type_object.csv"
    bucket       = var.bucket_tables
}

# -----------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_type_event" {
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id = "look_up_type_event"
    deletion_protection = false
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucket_tables}/${google_storage_bucket_object.look_up_type_event_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_type_event_object]
}

resource "google_storage_bucket_object" "look_up_type_event_object" {
    name         = "lk_tables/look_up_type_event_object.csv"
    content_type = "csv"
    source       = "../bigquery/tables/look_up_type_event_object.csv"
    bucket       = var.bucket_tables
}

# -----------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_active_lock_reason_type" {
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id = "look_up_active_lock_reason_type"
    deletion_protection = false    
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucket_tables}/${google_storage_bucket_object.look_up_active_lock_reason_type_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_active_lock_reason_type_object]
}

resource "google_storage_bucket_object" "look_up_active_lock_reason_type_object" {
    name         = "lk_tables/look_up_active_lock_reason_type_object.csv"
    content_type = "csv"
    source       = "../bigquery/tables/look_up_active_lock_reason_type_object.csv"
    bucket       = var.bucket_tables
}

# -----------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_author_association" {
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id = "look_up_author_association"
    deletion_protection = false    
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucket_tables}/${google_storage_bucket_object.look_up_author_association_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_author_association_object]
}

resource "google_storage_bucket_object" "look_up_author_association_object" {
    name         = "lk_tables/look_up_author_association_object.csv"
    content_type = "csv"
    source       = "../bigquery/tables/look_up_author_association_object.csv"
    bucket       = var.bucket_tables
}
# -----------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_issue_state" {
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id = "look_up_issue_state"
    deletion_protection = false    
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucket_tables}/${google_storage_bucket_object.look_up_issue_state_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_issue_state_object]
}

resource "google_storage_bucket_object" "look_up_issue_state_object" {
    name         = "lk_tables/look_up_issue_state_object.csv"
    content_type = "csv"
    source       = "../bigquery/tables/look_up_issue_state_object.csv"
    bucket       = var.bucket_tables
}

# -----------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_mergeable_state_type" {
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id = "look_up_mergeable_state_type"
    deletion_protection = false    
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucket_tables}/${google_storage_bucket_object.look_up_mergeable_state_type_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_mergeable_state_type_object]
}

resource "google_storage_bucket_object" "look_up_mergeable_state_type_object" {
    name         = "lk_tables/look_up_mergeable_state_type_object.csv"
    content_type = "csv"
    source       = "../bigquery/tables/look_up_mergeable_state_type_object.csv"
    bucket       = var.bucket_tables
}

# -----------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_pull_requests_state" {
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id = "look_up_pull_requests_state"
    deletion_protection = false    
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucket_tables}/${google_storage_bucket_object.look_up_pull_requests_state_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_pull_requests_state_object]
}

resource "google_storage_bucket_object" "look_up_pull_requests_state_object" {
    name         = "lk_tables/look_up_pull_requests_state_object.csv"
    content_type = "csv"
    source       = "../bigquery/tables/look_up_pull_requests_state_object.csv"
    bucket       = var.bucket_tables
}

# -----------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_pusher_type" {
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id = "look_up_pusher_type"
    deletion_protection = false    
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucket_tables}/${google_storage_bucket_object.look_up_pusher_type_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_pusher_type_object]
}

resource "google_storage_bucket_object" "look_up_pusher_type_object" {
    name         = "lk_tables/look_up_pusher_type_object.csv"
    content_type = "csv"
    source       = "../bigquery/tables/look_up_pusher_type_object.csv"
    bucket       = var.bucket_tables
}

# -----------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_ref_type" {
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id = "look_up_ref_type"
    deletion_protection = false    
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucket_tables}/${google_storage_bucket_object.look_up_ref_type_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_ref_type_object]
}

resource "google_storage_bucket_object" "look_up_ref_type_object" {
    name         = "lk_tables/look_up_ref_type_object.csv"
    content_type = "csv"
    source       = "../bigquery/tables/look_up_ref_type_object.csv"
    bucket       = var.bucket_tables
}

# -----------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_side_type" {
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id = "look_up_side_type"
    deletion_protection = false    
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucket_tables}/${google_storage_bucket_object.look_up_side_type_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_side_type_object]
}

resource "google_storage_bucket_object" "look_up_side_type_object" {
    name         = "lk_tables/look_up_side_type_object.csv"
    content_type = "csv"
    source       = "../bigquery/tables/look_up_side_type_object.csv"
    bucket       = var.bucket_tables
}

# -----------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_user_type" {
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id = "look_up_user_type"
    deletion_protection = false    
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucket_tables}/${google_storage_bucket_object.look_up_user_type_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_user_type_object]
}

resource "google_storage_bucket_object" "look_up_user_type_object" {
    name         = "lk_tables/look_up_user_type_object.csv"
    content_type = "csv"
    source       = "../bigquery/tables/look_up_user_type_object.csv"
    bucket       = var.bucket_tables
}

# -----------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_visibility_type" {
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id = "look_up_visibility_type"
    deletion_protection = false    
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucket_tables}/${google_storage_bucket_object.look_up_visibility_type_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_visibility_type_object]
}

resource "google_storage_bucket_object" "look_up_visibility_type_object" {
    name         = "lk_tables/look_up_visibility_type_object.csv"
    content_type = "csv"
    source       = "../bigquery/tables/look_up_visibility_type_object.csv"
    bucket       = var.bucket_tables
}

# -----------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------


resource "google_bigquery_table" "dimentional_user_table" {
    
    project = var.project
    
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id   = "dimentional_user_table"
    description = ""
    deletion_protection = false

    schema = <<EOF
[
  {
    "name": "user_id",
    "type": "INT64",
    "mode": "REQUIRED",
    "description": ""
  },
  {
    "name": "user_name",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": ""
  },
  {
    "name": "user_url",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": ""
  }
]
EOF

    table_constraints {
        primary_key  {
            columns = ["user_id"]
        }
    }

}


resource "google_bigquery_table" "dimentional_repository_table" {
    
    project = var.project
    
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id   = "dimentional_repository_table"
    description = ""
    deletion_protection = false

    schema = <<EOF
[
  {
    "name": "repository_id",
    "type": "INT64",
    "mode": "REQUIRED",
    "description": ""
  },
  {
    "name": "repository_name",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": ""
  },
  {
    "name": "repository_url",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": ""
  }
]
EOF

    table_constraints {
        primary_key  {
            columns = ["repository_id"]
        }
    }

}


resource "google_bigquery_table" "dimentional_organization_table" {
    
    project = var.project
    
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id   = "dimentional_organization_table"
    description = ""
    deletion_protection = false
  
    schema = <<EOF
[
  {
    "name": "organization_id",
    "type": "INT64",
    "mode": "REQUIRED",
    "description": ""
  },
  {
    "name": "organization_name",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": ""
  },
  {
    "name": "organization_url",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": ""
  }
]
EOF

    table_constraints {
        primary_key  {
            columns = ["organization_id"]
        }
    }

}


resource "google_bigquery_table" "dimentional_language_table" {
    
    project = var.project
    
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id   = "dimentional_language_table"
    description = ""
    deletion_protection = false

    schema = <<EOF
[
  {
    "name": "language_id",
    "type": "INT64",
    "mode": "REQUIRED",
    "description": ""
  },
  {
    "name": "language_name",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": ""
  }
]
EOF

    table_constraints {
        primary_key  {
            columns = ["language_id"]
        }
    }

}

# -----------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------

# resource "google_bigquery_table" "fact_allowed_events_table" {
#     
#     project = var.project
#     
#     dataset_id = google_bigquery_dataset.dataset.dataset_id
#     table_id   = "fact_allowed_events_table"
#     description = ""
# 
#     schema = <<EOF
# [
#   {
#     "name": "event_id",
#     "type": "INT64",
#     "mode": "REQUIRED",
#     "description": ""
#   },
#   {
#     "name": "event_type",
#     "type": "INT",
#     "mode": "REQUIRED",
#     "description": ""
#   },
#   {
#     "name": "repository_id",
#     "type": "INT64",
#     "mode": "REQUIRED",
#     "description": ""
#   },
#   {
#     "name": "actor_id",
#     "type": "INT64",
#     "mode": "REQUIRED",
#     "description": ""
#   },
#   {
#     "name": "org_id",
#     "type": "INT64",
#     "mode": "NULLABLE",
#     "description": ""
#   },
#   {
#     "name": "created_at",
#     "type": "DATETIME",
#     "mode": "REQUIRED",
#     "description": ""
#   },
#   {
#     "name": "created_at_date",
#     "type": "DATE",
#     "mode": "REQUIRED",
#     "description": ""
#   },
# ]
#     EOF
# 
# 
#     time_partitioning {
#         type = "DAY"
#         field = "created_at_date"
#     }
# 
#     table_constraints {
#         primary_key  {
#             columns = ["event_id"]
#         }
#         foreign_keys {
#             name = "event_type"
#             referenced_table {
#                 project_id = var.project
#                 dataset_id = google_bigquery_dataset.dataset.dataset_id
#                 table_id = google_bigquery_table.look_up_type_event.table_id
#             }
#             column_references {
#                 referencing_column = "event_type"
#                 referenced_column = "id"
#             }
#         }
#         foreign_keys {
#             name = "repository_id"
#             referenced_table {
#                 project_id = var.project
#                 dataset_id = google_bigquery_dataset.dataset.dataset_id
#                 table_id = google_bigquery_table.dimentional_repository_table.table_id
#             }
#             column_references {
#                 referencing_column = "repository_id"
#                 referenced_column = "repository_id"
#             }
#         }
#         foreign_keys {
#             name = "actor_id"
#             referenced_table {
#                 project_id = var.project
#                 dataset_id = google_bigquery_dataset.dataset.dataset_id
#                 table_id = google_bigquery_table.dimentional_user_table.table_id
#             }
#             column_references {
#                 referencing_column = "actor_id"
#                 referenced_column = "user_id"
#             }
#         }
#         foreign_keys {
#             name = "org_id"
#             referenced_table {
#                 project_id = var.project
#                 dataset_id = google_bigquery_dataset.dataset.dataset_id
#                 table_id = google_bigquery_table.dimentional_organization_table.table_id
#             }
#             column_references {
#                 referencing_column = "org_id"
#                 referenced_column = "organization_id"
#             }
#         }
#     }
# 
#     clustering = ["event_type"]
# 
# }


resource "google_bigquery_table" "external_table_allowed_events" {

    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id   = "external_table_allowed_events"
    deletion_protection = false

    external_data_configuration {
        autodetect    = true
        source_format = "PARQUET"

        source_uris = ["gs://${var.bucket_tables}/gh-archives/processed/allowed_events/*.parquet"]

        hive_partitioning_options {
            # mode = "AUTO"
            # source_uri_prefix = "gs://${var.bucket_tables}/gh-archives/processed/allowed_events/"
            mode = "CUSTOM"
            source_uri_prefix = "gs://${var.bucket_tables}/gh-archives/processed/allowed_events/{created_at_date:DATE}"
            # source_uri_prefix = "gs://${var.bucket_tables}/gh-archives/processed/allowed_events/{create_at_date=STRING}"
            require_partition_filter = true
        }
    }

    table_constraints {
        primary_key  {
            columns = ["event_id"]
        }
    }

}

# -----------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------