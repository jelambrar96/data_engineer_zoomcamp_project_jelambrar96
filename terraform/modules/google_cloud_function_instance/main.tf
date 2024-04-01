
# create ZIP file for Cloud Function
data "archive_file" "cloud_function_download_code" {
    type  = "zip"
    source_dir = "${path.root}/../gfunctions/download_function/"
    output_path = "${path.root}/../gfunctions/download_function.zip"
}

# Upload ZIP file
resource "google_storage_bucket_object" "cloud_function_download_archive" {
    name = "download_function.zip"
    bucket = var.general_purpose_bucket_name
    source = "${path.root}/../gfunctions/download_function.zip"
}

# Create Cloud Function Instance
# resource "google_cloudfunctions_function" "cloud_function_download_instance" {
#     name = "${var.project}-download-google-function"
#     description = "Cloud Function to download GH archive data"
#     runtime = "python39"
# 
#     available_memory_mb = 2048
#     source_archive_bucket = var.general_purpose_bucket_name
#     source_archive_object = google_storage_bucket_object.cloud_function_download_archive.name
#     trigger_http = true
#     entry_point = "download_gh_archive_data"
# 
#     environment_variables = {
#         BUCKET_NAME = var.general_purpose_bucket_name
#     }
# 
# }

resource "google_cloudfunctions2_function" "cloud_function_download_instance" {
    name = "${var.project}-download-google-function"
    description = "Cloud Function to download GH archive data"
    location = var.region


    build_config {
        runtime = "python39"
        entry_point = "download_gh_archive_data"
        environment_variables = {
            BUCKET_NAME = var.data_lake_bucket_name
        }
        source {
            storage_source {
                bucket =  var.general_purpose_bucket_name
                object = google_storage_bucket_object.cloud_function_download_archive.name
            }
        }
    }

    service_config {
        max_instance_count  = 1
        available_memory    = "2Gi"
        timeout_seconds     = 60

        environment_variables = {
            BUCKET_NAME = var.data_lake_bucket_name
        }
    }

}


# resource "google_cloud_scheduler_job" "invoke_cloud_function" {
#   name        = "invoke-gcf-function"
#   description = "Schedule the HTTPS trigger for cloud function"
#   project     = google_cloudfunctions2_function.cloud_function_download_instance.project
#   region      = google_cloudfunctions2_function.cloud_function_download_instance.project
# 
#   http_target {
#     uri         = google_cloudfunctions2_function.cloud_function_download_instance.service_config[0].uri
#     http_method = "POST"
#     oidc_token {
#       audience              = "${google_cloudfunctions2_function.cloud_function_download_instance.service_config[0].uri}/"
#       service_account_email = google_service_account.account.email
#     }
#   }
# }

resource "google_cloud_run_service_iam_member" "member" {
  location = google_cloudfunctions2_function.cloud_function_download_instance.location
  service  = google_cloudfunctions2_function.cloud_function_download_instance.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

