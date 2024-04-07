resource "google_bigquery_dataset" "dataset" {
    dataset_id                  = "${var.project}-gharchive-dataset"
    friendly_name               = "gharchive-dataset"
    description                 = ""
    location                    = "${var.region}"

    default_encryption_configuration {
        kms_key_name = google_kms_crypto_key.crypto_key.id
    }
}

resource "google_kms_crypto_key" "crypto_key" {
    name     = "google_kms_crypto_key"
    key_ring = google_kms_key_ring.key_ring.id
}

resource "google_kms_key_ring" "key_ring" {
    name     = "google_kms_key_ring"
    location = "us"
}

# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_action_type" {
    dataset_id = google_bigquery_dataset.dataset.id
    table_id = "look_up_action_type"
    deletion_protection = true
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucker_tables}/lk_tables/${google_storage_bucket_object.look_up_action_type_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_action_type_object]
}

resource "google_storage_bucket_object" "look_up_action_type_object" {
    name         = "look_up_action_type_object.csv"
    content_type = "csv"
    source       = "../biquery/tables/look_up_action_type_object.csv"
    bucket       = var.bucker_tables
}

# -----------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_type_event" {
    dataset_id = google_bigquery_dataset.dataset.id
    table_id = "look_up_type_event"
    deletion_protection = true
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucker_tables}/lk_tables/${google_storage_bucket_object.look_up_type_event_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_type_event_object]
}

resource "google_storage_bucket_object" "look_up_type_event_object" {
    name         = "look_up_type_event_object.csv"
    content_type = "csv"
    source       = "../biquery/tables/look_up_type_event_object.csv"
    bucket       = var.bucker_tables
}

# -----------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_active_lock_reason_type" {
    dataset_id = google_bigquery_dataset.dataset.id
    table_id = "look_up_active_lock_reason_type"
    deletion_protection = true
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucker_tables}/lk_tables/${google_storage_bucket_object.look_up_active_lock_reason_type_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_active_lock_reason_type_object]
}

resource "google_storage_bucket_object" "look_up_active_lock_reason_type_object" {
    name         = "look_up_active_lock_reason_type_object.csv"
    content_type = "csv"
    source       = "../biquery/tables/look_up_active_lock_reason_type_object.csv"
    bucket       = var.bucker_tables
}

# -----------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_author_association" {
    dataset_id = google_bigquery_dataset.dataset.id
    table_id = "look_up_author_association"
    deletion_protection = true
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucker_tables}/lk_tables/${google_storage_bucket_object.look_up_author_association_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_author_association_object]
}

resource "google_storage_bucket_object" "look_up_author_association_object" {
    name         = "look_up_author_association_object.csv"
    content_type = "csv"
    source       = "../biquery/tables/look_up_author_association_object.csv"
    bucket       = var.bucker_tables
}
# -----------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_issue_state" {
    dataset_id = google_bigquery_dataset.dataset.id
    table_id = "look_up_issue_state"
    deletion_protection = true
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucker_tables}/lk_tables/${google_storage_bucket_object.look_up_issue_state_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_issue_state_object]
}

resource "google_storage_bucket_object" "look_up_issue_state_object" {
    name         = "look_up_issue_state_object.csv"
    content_type = "csv"
    source       = "../biquery/tables/look_up_issue_state_object.csv"
    bucket       = var.bucker_tables
}

# -----------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_mergeable_state_type" {
    dataset_id = google_bigquery_dataset.dataset.id
    table_id = "look_up_mergeable_state_type"
    deletion_protection = true
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucker_tables}/lk_tables/${google_storage_bucket_object.look_up_mergeable_state_type_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_mergeable_state_type_object]
}

resource "google_storage_bucket_object" "look_up_mergeable_state_type_object" {
    name         = "look_up_mergeable_state_type_object.csv"
    content_type = "csv"
    source       = "../biquery/tables/look_up_mergeable_state_type_object.csv"
    bucket       = var.bucker_tables
}

# -----------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_pull_requests_state" {
    dataset_id = google_bigquery_dataset.dataset.id
    table_id = "look_up_pull_requests_state"
    deletion_protection = true
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucker_tables}/lk_tables/${google_storage_bucket_object.look_up_pull_requests_state_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_pull_requests_state_object]
}

resource "google_storage_bucket_object" "look_up_pull_requests_state_object" {
    name         = "look_up_pull_requests_state_object.csv"
    content_type = "csv"
    source       = "../biquery/tables/look_up_pull_requests_state_object.csv"
    bucket       = var.bucker_tables
}

# -----------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_pusher_type" {
    dataset_id = google_bigquery_dataset.dataset.id
    table_id = "look_up_pusher_type"
    deletion_protection = true
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucker_tables}/lk_tables/${google_storage_bucket_object.look_up_pusher_type_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_pusher_type_object]
}

resource "google_storage_bucket_object" "look_up_pusher_type_object" {
    name         = "look_up_pusher_type_object.csv"
    content_type = "csv"
    source       = "../biquery/tables/look_up_pusher_type_object.csv"
    bucket       = var.bucker_tables
}

# -----------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_ref_type" {
    dataset_id = google_bigquery_dataset.dataset.id
    table_id = "look_up_ref_type"
    deletion_protection = true
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucker_tables}/lk_tables/${google_storage_bucket_object.look_up_ref_type_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_ref_type_object]
}

resource "google_storage_bucket_object" "look_up_ref_type_object" {
    name         = "look_up_ref_type_object.csv"
    content_type = "csv"
    source       = "../biquery/tables/look_up_ref_type_object.csv"
    bucket       = var.bucker_tables
}

# -----------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_side_type" {
    dataset_id = google_bigquery_dataset.dataset.id
    table_id = "look_up_side_type"
    deletion_protection = true
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucker_tables}/lk_tables/${google_storage_bucket_object.look_up_side_type_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_side_type_object]
}

resource "google_storage_bucket_object" "look_up_side_type_object" {
    name         = "look_up_side_type_object.csv"
    content_type = "csv"
    source       = "../biquery/tables/look_up_side_type_object.csv"
    bucket       = var.bucker_tables
}
# -----------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_type_event" {
    dataset_id = google_bigquery_dataset.dataset.id
    table_id = "look_up_type_event"
    deletion_protection = true
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucker_tables}/lk_tables/${google_storage_bucket_object.look_up_type_event_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_type_event_object]
}

resource "google_storage_bucket_object" "look_up_type_event_object" {
    name         = "look_up_type_event_object.csv"
    content_type = "csv"
    source       = "../biquery/tables/look_up_type_event_object.csv"
    bucket       = var.bucker_tables
}

# -----------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_user_type" {
    dataset_id = google_bigquery_dataset.dataset.id
    table_id = "look_up_user_type"
    deletion_protection = true
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucker_tables}/lk_tables/${google_storage_bucket_object.look_up_user_type_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_user_type_object]
}

resource "google_storage_bucket_object" "look_up_user_type_object" {
    name         = "look_up_user_type_object.csv"
    content_type = "csv"
    source       = "../biquery/tables/look_up_user_type_object.csv"
    bucket       = var.bucker_tables
}

# -----------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------

resource "google_bigquery_table" "look_up_visibility_type" {
    dataset_id = google_bigquery_dataset.dataset.id
    table_id = "look_up_visibility_type"
    deletion_protection = true
    external_data_configuration {
        autodetect = true
        source_uris =["gs://${var.bucker_tables}/lk_tables/${google_storage_bucket_object.look_up_visibility_type_object.name}"]
        source_format = "CSV"
    }
    depends_on = [google_storage_bucket_object.look_up_visibility_type_object]
}

resource "google_storage_bucket_object" "look_up_visibility_type_object" {
    name         = "look_up_visibility_type_object.csv"
    content_type = "csv"
    source       = "../biquery/tables/look_up_visibility_type_object.csv"
    bucket       = var.bucker_tables
}

# -----------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------


