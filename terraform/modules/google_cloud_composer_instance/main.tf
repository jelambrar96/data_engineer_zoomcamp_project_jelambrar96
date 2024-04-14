
# Create composer Environment
resource "google_composer_environment" "composer_service" {
  name   = "${var.project}-composer-env"
  project = var.project
  region = var.region
  
  config {

    software_config {

      image_version = "composer-2.6.6-airflow-2.6.3"

      airflow_config_overrides = {
        core-dags_are_paused_at_creation = "True"
      }

      env_variables = {
        START_DATE: "2024-04-12",

        DATAPROC_MASTER_DISK_SIZE: 512,
        DATAPROC_WORKER_DISK_SIZE: 512,
        DATAPROC_MASTER_MACHINE_TYPE: var.dataproc_master_machine_type,
        DATAPROC_WORKER_MACHINE_TYPE: var.dataproc_worker_machine_type,
        DATAPROC_CLUSTER_NAME: var.dataproc_cluster_name,
        DATAPROC_PYTHON_SCRIPTS_PATH: var.dataproc_python_script_path # "gs://${var.pyspark_repo_bucket_name}",
        DATAPROC_NUM_WORKERS: var.dataproc_num_workers,
        DATAPROC_NUM_MASTERS: var.dataproc_num_masters,
        # DATAPROC_MASTER_DISK_TYPE = var.dataproc_master_disk_type,
        # DATAPROC_WORKER_DISK_TYPE = var.dataproc_worker_disk_type

        GOOGLE_CLOUD_PROJECT_ID: var.project,
        GOOGLE_CLOUD_REGION: var.region,
        GOOGLE_CLOUD_ZONE: var.zone,

        GOOGLE_CLOUD_STORAGE_BUCKET: var.pyspark_repo_bucket_name,
        GOOGLE_CLOUD_DATAWAREHOUSE_BUCKET: var.data_warehouse_bucket_name,
        GOOGLE_CLOUD_DATALAKE_BUCKET: var.data_lake_bucket_name,

        GOOGLE_CLOUD_STORAGE_DESTINATION_FILES: "gs://${var.data_warehouse_bucket_name}/gh-archives/processed/",
        GOOGLE_CLOUD_STORAGE_SOURCE_FILES: "gs://${var.data_lake_bucket_name}/gh-archives/raw/{0}/*",

        DOWNLOAD_GH_DATA_CLOUD_FUNCTION: var.cloud_fuction_link
      }

    }

    environment_size = "ENVIRONMENT_SIZE_SMALL"

  }

  storage_config {
    bucket = var.composer_bucket_name
  }

}

locals {
  bucket_path = google_composer_environment.composer_service.config.0.dag_gcs_prefix
  project_id  = split("/", local.bucket_path)[2]
}

resource "google_storage_bucket_object" "pyspark_repo_archive" {
  for_each = fileset("../composer/dags/", "*.py")

  name   = "dags/${each.key}"
  bucket = local.project_id
  source = "../composer/dags/${each.key}"
}

