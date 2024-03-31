output "cloud_fuction_link" {
  # value = google_cloudfunctions_function.cloud_function_download_instance.https_trigger_url
  value = google_cloudfunctions2_function.cloud_function_download_instance.service_config[0].uri
}