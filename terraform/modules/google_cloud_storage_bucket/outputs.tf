
output "data_warehouse_bucket_name" {
  value = google_storage_bucket.data_warehouse_bucket.name
}

output "general_purpose_bucket_name" {
  value = google_storage_bucket.general_purpose_bucket.name
}

output "dataproc_bucket_name" {
  value = google_storage_bucket.dataproc_bucket.name
}
