terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6"
    }
  }
}

provider "google" {
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
  composer_bucket_name = module.google_cloud_storage_bucket.composer_bucket_name
  data_warehouse_bucket_name = module.google_cloud_storage_bucket.data_warehouse_bucket_name
  cloud_fuction_link = module.google_cloud_function_instance.cloud_fuction_link
  dataproc_cluster_name = module.google_cloud_storage_bucket.dataproc_bucket_name
  pyspark_repo_bucket_name = module.google_cloud_storage_bucket.dataproc_bucket_name
}

# module "google_project_service_api" {
#     source = "./modules/google_project_service_api"
#     project = var.project
# }

