terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6"
    }
  }
}

provider "google" {
  credentials = file("./keys/credentials.json")
  project = var.project
  region  = var.region
  zone    = var.zone
}

module "google_cloud_storage_bucket" {
  source  = "./modules/google_cloud_storage_bucket"
  project = var.project
  region  = var.region
  zone = var.zone
}

module "google_cloud_function_instance" {
  source = "./modules/google_cloud_function_instance"
  project = var.project
  region  = var.region
  zone = var.zone
  general_purpose_bucket_name = module.google_cloud_storage_bucket.general_purpose_bucket_name
  data_warehouse_bucket_name = module.google_cloud_storage_bucket.data_warehouse_bucket_name
  data_lake_bucket_name = module.google_cloud_storage_bucket.data_lake_bucket_name
}

module "google_cloud_composer_instance" {
  source = "./modules/google_cloud_composer_instance"
  project = var.project
  region  = var.region
  zone = var.zone

  dataproc_cluster_name = module.google_dataproc_instance.dataproc_cluster_name
  dataproc_num_masters = module.google_dataproc_instance.dataproc_num_masters_instances
  dataproc_num_workers = module.google_dataproc_instance.dataproc_num_workers_instances
  dataproc_master_machine_type = module.google_dataproc_instance.dataproc_master_machine_type
  dataproc_worker_machine_type = module.google_dataproc_instance.dataproc_worker_machine_type
  # dataproc_master_disk_type = module.google_dataproc_instance.dataproc_master_disk_type
  # dataproc_worker_disk_type = module.google_dataproc_instance.dataproc_worker_disk_type
  dataproc_python_script_path = module.google_dataproc_instance.dataproc_python_script_link

  bigquery_dataset_id = module.google_bigquery_dataset.dataset_id

  composer_bucket_name = module.google_cloud_storage_bucket.composer_bucket_name
  data_lake_bucket_name = module.google_cloud_storage_bucket.data_lake_bucket_name 
  data_warehouse_bucket_name = module.google_cloud_storage_bucket.data_warehouse_bucket_name  
  pyspark_repo_bucket_name = module.google_cloud_storage_bucket.dataproc_bucket_name
  
  cloud_fuction_link = module.google_cloud_function_instance.cloud_fuction_link
}

module "google_dataproc_instance" {
  source = "./modules/google_cloud_dataproc_instance"
  project = var.project
  region = var.region
  zone = var.zone
  dataproc_bucket_name = module.google_cloud_storage_bucket.dataproc_bucket_name
}

# module "google_project_service_api" {
#     source = "./modules/google_project_service_api"
#     project = var.project
# }

module "google_bigquery_dataset" {
  source = "./modules/google_cloud_bigquery_dataset"
  project = var.project
  region = var.region
  zone = var.zone
  bucket_tables = module.google_cloud_storage_bucket.data_warehouse_bucket_name
}
