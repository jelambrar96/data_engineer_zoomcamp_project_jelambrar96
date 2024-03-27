output "composer_uri" {
  value = google_composer_environment.composer_service.config.0.composer_uri
}

output "composer_dag_folder" {
  value = google_composer_environment.composer_service.config.0.dag_gcs_prefix
}
