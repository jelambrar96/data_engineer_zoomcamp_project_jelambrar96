
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
resource "google_cloudfunctions_function" "cloud_function_download_instance" {
    name = "${var.project}-download-google-function"
    description = "Cloud Function to download GH archive data"
    runtime = "python39"

    available_memory_mb = 2048
    source_archive_bucket = var.general_purpose_bucket_name
    source_archive_object = google_storage_bucket_object.cloud_function_download_archive.name
    trigger_http = true
    entry_point = "download_gh_archive_data"

    environment_variables = {
        BUCKET_NAME = var.data_warehouse_bucket_name
    }

}

